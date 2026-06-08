import 'dart:async';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/model/pays_model.dart';
import 'package:chapchap/model/transfer_calculation_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart'; 
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ExchangeView extends StatefulWidget {
  bool? public;
  ExchangeView({Key? key, this.public}) : super(key: key);

  @override
  State<ExchangeView> createState() => _ExchangeViewState();
}

class _ExchangeViewState extends State<ExchangeView> with SingleTickerProviderStateMixin {
  final DemandesViewModel demandesViewModel = DemandesViewModel();
  final DemandesViewModel _calculateViewModel = DemandesViewModel();
  PaysModel selectedFrom = PaysModel();
  Destination? selectedTo;
  PaysDestinationModel? paysDestinationModel;
  bool changed = false;

  TransferCalculation? _transferCalculation;
  bool _isCalculating = false;
  bool _isUpdatingControllersFromApi = false;
  bool fromToToSens = true;
  Timer? _calculateDebounce;
  int _calculateSequence = 0;

  UserModel? user;

  late AnimationController _controller;
  late Animation<double> _animation;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
    demandesViewModel.paysActifs([], context);

  }

  @override
  void dispose() {
    _calculateDebounce?.cancel();
    _amountController.dispose();
    _toController.dispose();
    _controller.dispose();
    super.dispose();
  }

  String? get _sourceCurrency =>
      paysDestinationModel?.paysCodeMonnaieSrce ?? selectedFrom.paysCodemonnaie;

  String _countryCode(String? code) => (code ?? '').toUpperCase();

  void _clearCalculation() {
    _transferCalculation = null;
    _isCalculating = false;
  }

  int _decimalsForSource() => 2;

  int _decimalsForDestination() {
    final code = selectedTo?.paysCodeMonnaieDest?.toUpperCase();
    if (code == 'XOF' || code == 'XAF') return 0;
    return 2;
  }

  String _formatAmount(double value, {int? decimals}) {
    final d = decimals ?? 2;
    if (d == 0) return value.round().toString();
    final formatted = value.toStringAsFixed(d);
    final dotIndex = formatted.indexOf('.');
    if (dotIndex == -1) return formatted;
    final fraction = formatted.substring(dotIndex + 1);
    if (fraction.replaceAll('0', '').isEmpty) {
      return formatted.substring(0, dotIndex);
    }
    return formatted;
  }

  bool _isDouble(String value) => double.tryParse(value.trim()) != null;

  String _displayValue({
    required bool isSource,
    required String controllerText,
    bool sendExcludeFees = false,
  }) {
    if (_isCalculating) return '-';
    if (_transferCalculation != null) {
      final amount = isSource
          ? (sendExcludeFees
              ? _transferCalculation!.amountSource
              : _transferCalculation!.amountYouSend)
          : _transferCalculation!.amountDestination;
      return _formatAmount(
        amount,
        decimals: isSource ? _decimalsForSource() : _decimalsForDestination(),
      );
    }
    if (controllerText.isEmpty) return '-';
    return controllerText;
  }

  String _displayFees() {
    if (_isCalculating) return '-';
    if (_transferCalculation == null) return '-';
    final currency = _sourceCurrency ?? '';
    final calc = _transferCalculation!;
    final frais = calc.feesFixed + calc.feesVariable;
    return '${_formatAmount(frais > 0 ? frais : calc.amountFees)} $currency';
  }

  void _onAmountInputChanged({required bool fromSource, required String value}) {
    if (_isUpdatingControllersFromApi) return;

    if (selectedTo == null || paysDestinationModel == null) {
      Utils.flushBarErrorMessage(
        AppLocalizations.of(context)!.translate('selectDestinationCountry'),
        context,
      );
      return;
    }

    setState(() {
      fromToToSens = fromSource;
      _isCalculating = true;
      _transferCalculation = null;
      if (fromSource) {
        _toController.clear();
      } else {
        _amountController.clear();
      }
    });

    _calculateDebounce?.cancel();

    final trimmed = value.trim();
    if (trimmed.isEmpty || !_isDouble(trimmed)) {
      setState(() {
        _isCalculating = false;
        _clearCalculation();
        if (trimmed.isEmpty) {
          if (fromSource) {
            _toController.clear();
          } else {
            _amountController.clear();
          }
        }
      });
      return;
    }

    _calculateDebounce = Timer(const Duration(milliseconds: 450), () {
      _requestCalculation(fromSource: fromSource, amount: double.parse(trimmed));
    });
  }

  Future<void> _requestCalculation({
    required bool fromSource,
    required double amount,
  }) async {
    if (paysDestinationModel == null || selectedTo == null) return;

    final sequence = ++_calculateSequence;
    final codePaysSource = _countryCode(
      paysDestinationModel!.codePaysSrce ?? selectedFrom.codePays,
    );
    final codePaysDestination = _countryCode(selectedTo!.codePaysDest);

    final payload = <String, dynamic>{
      'code_sens': '$codePaysSource-$codePaysDestination',
      'code_pays_source': codePaysSource,
      'code_pays_destination': codePaysDestination,
      'amount_source': fromSource ? amount : 0,
      'amount_destination': fromSource ? 0 : amount,
      'code_promo': '',
      'amount_with_fee': true,
    };

    final result = await _calculateViewModel.calculateTransfer(context, payload);

    if (!mounted || sequence != _calculateSequence) return;

    if (result == null) {
      setState(() => _isCalculating = false);
      return;
    }

    if (!result.isOk) {
      setState(() => _isCalculating = false);
      if (result.promoError != null && result.promoError!.isNotEmpty) {
        Utils.flushBarErrorMessage(result.promoError!, context);
      }
      return;
    }

    _applyCalculationResult(result, fromSource: fromSource);
  }

  void _applyCalculationResult(TransferCalculation result, {required bool fromSource}) {
    _isUpdatingControllersFromApi = true;
    _amountController.text = _formatAmount(
      result.amountYouSend,
      decimals: _decimalsForSource(),
    );
    _toController.text = _formatAmount(
      result.amountDestination,
      decimals: _decimalsForDestination(),
    );
    _isUpdatingControllersFromApi = false;

    setState(() {
      _transferCalculation = result;
      _isCalculating = false;
      fromToToSens = fromSource;
    });
  }

  void _resetAmountsOnRouteChange() {
    _calculateDebounce?.cancel();
    _amountController.clear();
    _toController.clear();
    _clearCalculation();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyBordContainer(
      child: Scaffold(
        appBar: widget.public == true ? CommonAppBar(
          context: context,
          backArrow: true,
        ) : PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColors.bgColor,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
              systemNavigationBarDividerColor: Colors.white,
            ),
          ),
        ),
        backgroundColor: AppColors.bgColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.public != true)
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppTexts.titleText(AppLocalizations.of(context)!.translate('exchangeRate')),
              ),
              Expanded(
                child: ChangeNotifierProvider<DemandesViewModel>(
                    create: (BuildContext context) => demandesViewModel,
                    child: Consumer<DemandesViewModel>(
                        builder: (context, value, _){
                          switch (value.paysActifList.status) {
                            case Status.LOADING:
                              return SizedBox(
                                height: MediaQuery.of(context).size.height - 200,
                                child: const Center(
                                  child: CupertinoActivityIndicator(color: Colors.black,),
                                ),
                              );
                            case Status.ERROR:
                              return Center(
                                child: Text(value.paysActifList.message.toString()),
                              );
                            default:
                              List paysActifsList = value.paysActifList.data!;
                              if (selectedFrom.codePays == null) {
                                selectedFrom = PaysModel.fromJson(paysActifsList[0]);
                              }
                              return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppTexts.bodyText(AppLocalizations.of(context)!.translate('source')),
                                    const SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        AppTexts.smallText(AppLocalizations.of(context)!.translate('selectShippingCountry')),
                                                        const SizedBox(height: 20,),
                                                        Expanded(child: ListView.builder(
                                                          itemCount: paysActifsList.length,
                                                          itemBuilder: (context, index) {
                                                            PaysModel current = PaysModel.fromJson(paysActifsList[index]);
                                                            return InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedFrom = current;
                                                                    selectedTo = null;
                                                                    changed = true;
                                                                    paysDestinationModel = null;
                                                                    _resetAmountsOnRouteChange();
                                                                  });
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Container(
                                                                  padding: const EdgeInsets.all(10),
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(width: 1, color: Colors.black.withOpacity(.1))
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Image.asset(
                                                                        "packages/country_icons/icons/flags/png/${current.codePays}.png",
                                                                        width: 20, height: 20, fit: BoxFit.contain,
                                                                      ),
                                                                      const SizedBox(width: 20,),
                                                                      Text(
                                                                        current.paysNom.toString(),
                                                                        style: const TextStyle(
                                                                            fontSize: 14, fontWeight: FontWeight.bold
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                            );
                                                          },
                                                        ))
                                                      ],
                                                    ),
                                                  );
                                                },
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: double.infinity, height: 50,
                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              decoration: BoxDecoration(
                                                  color: AppColors.formFieldColor,
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                      "packages/country_icons/icons/flags/png/${selectedFrom.codePays}.png",
                                                      width: 30, height: 20, fit: BoxFit.contain
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  const Expanded(
                                                    child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Icon(CupertinoIcons.chevron_down, size: 20,),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        SizedBox(
                                          width: (MediaQuery.of(context).size.width - 40 - 10 - 80),
                                          child: CustomFormField(
                                            hint: "0.00",
                                            controller: _amountController,
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.only(right: 20),
                                              child: AppTexts.bodyText(
                                                  selectedFrom.paysCodemonnaie.toString(),
                                                  bold: true
                                              ),
                                            ),
                                            type: TextInputType.number,
                                            onChanged: (value) =>
                                                _onAmountInputChanged(fromSource: true, value: value),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    AppTexts.bodyText(AppLocalizations.of(context)!.translate('destination')),
                                    const SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 80,
                                            child: InkWell(
                                              onTap: () {
                                                DemandesViewModel newDemandeViewModel = DemandesViewModel();
                                                if (paysDestinationModel == null || changed) {
                                                  newDemandeViewModel.allPaysDestinations(
                                                      {"id": selectedFrom.idPays.toString()}, context);
                                                }
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    if (paysDestinationModel == null || changed) {
                                                      changed = false;
                                                      return ChangeNotifierProvider<DemandesViewModel>(
                                                          create: (BuildContext context) => newDemandeViewModel,
                                                          child: Consumer<DemandesViewModel>(
                                                              builder: (context, value, _) {
                                                                switch (value.allPaysDestination.status) {
                                                                  case Status.LOADING:
                                                                    return Container(
                                                                      height: MediaQuery.of(context).size.height - 200,
                                                                      child: const Center(
                                                                        child: CupertinoActivityIndicator(color: Colors.black),
                                                                      ),
                                                                    );
                                                                  case Status.ERROR:
                                                                    return Center(
                                                                      child: Text(value.allPaysDestination.message.toString()),
                                                                    );
                                                                  default:
                                                                    paysDestinationModel = value.allPaysDestination.data!;
                                                                    return Container(
                                                                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                                                      child: Column(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          AppTexts.smallText(AppLocalizations.of(context)!.translate('selectDestinationCountry')),
                                                                          const SizedBox(height: 20,),
                                                                          Expanded(
                                                                              child: ListView.builder(
                                                                                itemCount: paysDestinationModel!.destination!.length,
                                                                                itemBuilder: (context, index) {
                                                                                  return InkWell(
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                      setState(() {
                                                                                        selectedTo = paysDestinationModel!.destination![index];
                                                                                        _resetAmountsOnRouteChange();
                                                                                      });
                                                                                    },
                                                                                    child: Container(
                                                                                      padding: const EdgeInsets.all(10),
                                                                                      decoration: BoxDecoration(
                                                                                          border: Border.all(width: 1, color: Colors.black.withOpacity(.1))
                                                                                      ),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Image.asset(
                                                                                            "packages/country_icons/icons/flags/png/${paysDestinationModel!.destination![index].codePaysDest}.png",
                                                                                            width: 20, height: 20, fit: BoxFit.contain,
                                                                                          ),
                                                                                          const SizedBox(width: 20,),
                                                                                          Text(
                                                                                            paysDestinationModel!.destination![index].paysDest.toString(),
                                                                                            style: const TextStyle(
                                                                                                fontSize: 14, fontWeight: FontWeight.bold
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              )
                                                                          )
                                                                        ],
                                                                      ),
                                                                    );
                                                                }
                                                              })
                                                      );
                                                    }
                                                    return Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          AppTexts.smallText(AppLocalizations.of(context)!.translate('selectDestinationCountry')),
                                                          const SizedBox(height: 20,),
                                                          Expanded(
                                                              child: ListView.builder(
                                                                itemCount: paysDestinationModel!.destination!.length,
                                                                itemBuilder: (context, index) {
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        selectedTo = paysDestinationModel!.destination![index];
                                                                        _resetAmountsOnRouteChange();
                                                                      });
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Container(
                                                                      padding: const EdgeInsets.all(10),
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(width: 1, color: Colors.black.withOpacity(.1))
                                                                      ),
                                                                      child: Row(
                                                                        children: [
                                                                          Image.asset(
                                                                            "packages/country_icons/icons/flags/png/${paysDestinationModel!.destination![index].codePaysDest}.png",
                                                                            width: 20, height: 20, fit: BoxFit.contain,
                                                                          ),
                                                                          const SizedBox(width: 20,),
                                                                          Text(
                                                                            paysDestinationModel!.destination![index].paysDest.toString(),
                                                                            style: const TextStyle(
                                                                                fontSize: 14, fontWeight: FontWeight.bold
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              )
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.vertical(
                                                      top: Radius.circular(20),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: double.infinity, height: 50,
                                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                decoration: BoxDecoration(
                                                    color: AppColors.formFieldColor,
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: selectedTo == null ? MainAxisAlignment.center : MainAxisAlignment.start,
                                                  children: [
                                                    if (selectedTo != null)
                                                      Image.asset(
                                                          "packages/country_icons/icons/flags/png/${selectedTo!.codePaysDest}.png",
                                                          width: 30, height: 20, fit: BoxFit.contain
                                                      ),
                                                    if (selectedTo == null)
                                                      AppTexts.cardTitle("_"),
                                                    const SizedBox(width: 10,),
                                                    const Expanded(
                                                      child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Icon(CupertinoIcons.chevron_down, size: 20,),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                        ),
                                        const SizedBox(width: 10,),
                                        SizedBox(
                                          width: (MediaQuery.of(context).size.width - 40 - 10 - 80),
                                          child: CustomFormField(
                                            hint: "0.00",
                                            controller: _toController,
                                            type: TextInputType.number,
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.only(right: 20),
                                              child: AppTexts.bodyText(selectedTo == null ? '-' : selectedTo!.paysCodeMonnaieDest.toString(), bold: true),
                                            ),
                                            onChanged: (value) =>
                                                _onAmountInputChanged(fromSource: false, value: value),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 20,),
                                    if (selectedFrom.idPays != null && selectedTo != null)
                                      ...[
                                        AppTexts.buttonText(
                                          _transferCalculation?.formule ??
                                              "${AppLocalizations.of(context)!.translate('exchangeRate1')} ${selectedFrom.paysCodemonnaie} = ${selectedTo!.rate} ${selectedTo!.paysCodeMonnaieDest}",
                                        ),
                                        const SizedBox(height: 20),
                                        commonRoundedContainer(
                                          removePaddingH: true,
                                          shadow: true,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    AppTexts.smallText(
                                                      AppLocalizations.of(context)!.translate('you_send'),
                                                    ),
                                                    _isCalculating
                                                        ? AppTexts.buttonText("- $_sourceCurrency")
                                                        : AppTexts.buttonText(
                                                            "${_displayValue(isSource: true, controllerText: _amountController.text, sendExcludeFees: true)} $_sourceCurrency",
                                                          ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              commonDivider(),
                                              const SizedBox(height: 5),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    AppTexts.smallText(
                                                      AppLocalizations.of(context)!.translate('beneficiary_receives'),
                                                    ),
                                                    _isCalculating
                                                        ? AppTexts.buttonText(
                                                            "- ${selectedTo!.paysCodeMonnaieDest}",
                                                          )
                                                        : AppTexts.buttonText(
                                                            "${_displayValue(isSource: false, controllerText: _toController.text)} ${selectedTo!.paysCodeMonnaieDest}",
                                                          ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              commonDivider(),
                                              const SizedBox(height: 5),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    AppTexts.smallText(
                                                      AppLocalizations.of(context)!.translate('transferFee'),
                                                    ),
                                                    Row(
                                                      children: [
                                                        if (_isCalculating)
                                                          const Padding(
                                                            padding: EdgeInsets.only(right: 8),
                                                            child: SizedBox(
                                                              width: 14,
                                                              height: 14,
                                                              child: CupertinoActivityIndicator(
                                                                radius: 7,
                                                                color: Colors.black54,
                                                              ),
                                                            ),
                                                          ),
                                                        AppTexts.buttonText(_displayFees()),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        Icon(Icons.info_outline_rounded, color: AppColors.primaryColor, size: 20,),
                                        const SizedBox(width: 10,),
                                        Flexible(child: AppTexts.descriptionText(AppLocalizations.of(context)!.translate('chapChapTransferInfo'))),
                                      ],
                                    )

                                  ],
                                ),
                              ),
                            );
                          }
                        })
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: user == null || widget.public == true ? null : FloatingActionButtonLocation.centerDocked,
        floatingActionButton: user == null || widget.public == true ? null : ScaleTransition(
          scale: _animation,
          child: FloatingActionButton(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.send);
            },
            child: const Icon(CupertinoIcons.arrow_up_right_circle, color: Colors.white, size: 35,),
          ),
        ),
        bottomNavigationBar: user == null || widget.public == true ? null : commonBottomAppBar(context: context, active: 2),
      ),
    );
  }
}