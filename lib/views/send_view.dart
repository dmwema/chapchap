import 'dart:async';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/data/response/api_response.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/motif_model.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/model/transfer_calculation_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/recipient_card2.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/pin_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:chapchap/views/new_beneficiaire.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class SendView extends StatefulWidget {
  BeneficiaireModel? beneficiaire;
  String? destination;
  Destination? selectedDestination;
  PaysDestinationModel? paysDestination;
  MotifModel? selectedMotif;
  double? amount;
  ModeRetrait? modeRetrait;
  MotifModel? motif;
  bool repeatFromHistory;
  bool repeatTransferValidated;
  List<dynamic>? prefilledBeneficiaires;
  List<MotifModel>? prefilledMotifs;
  SendView({
    super.key,
    this.beneficiaire,
    this.motif,
    this.modeRetrait,
    this.paysDestination,
    this.selectedDestination,
    this.destination,
    this.amount,
    this.repeatFromHistory = false,
    this.repeatTransferValidated = false,
    this.prefilledBeneficiaires,
    this.prefilledMotifs,
  });

  @override
  State<SendView> createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {
  static const int STEP_BENEFICIARY = 0;
  static const int STEP_AMOUNT = 1;
  static const int STEP_REASON = 2;
  static const int STEP_CONFIRMATION = 3;

  int step = STEP_BENEFICIARY;
  int steps = 4;
  late final PageController _controller;
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _searchBeneficiaireController = TextEditingController();
  final TextEditingController _promoContoller = TextEditingController();

  FocusNode? currentFocus = FocusManager.instance.primaryFocus;

  PaysDestinationModel? paysDestinationModel;
  Destination? selectedDesinaion;
  ModeRetrait? selectedModeRetrait;
  MotifModel? selectedMotif;
  BeneficiaireModel? selectedBeneficiaire;
  UserModel? user;

  bool fromToToSens = true;
  bool initBen = false;
  bool loadedDestination = false;
  bool loadedModeRetrait = false;
  bool loadedMotif = false;
  bool _initialCalculationRequested = false;
  bool _beneficiaryValidationFailed = false;
  bool loading = false;
  bool loadingPromo = false;
  bool loadingPromoSucces = false;

  TransferCalculation? _transferCalculation;
  bool _isCalculating = false;
  bool _isUpdatingControllersFromApi = false;
  Timer? _calculateDebounce;
  int _calculateSequence = 0;

  double get promoRabais => _transferCalculation?.promoReduction ?? 0;
  String promoCode = '';

  bool promo = false;

  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 2));

  List<MotifModel> motifs = [];

  final DemandesViewModel demandesViewModel = DemandesViewModel();
  final DemandesViewModel demandesViewModel2 = DemandesViewModel();
  final DemandesViewModel demandesViewModel3 = DemandesViewModel();
  final DemandesViewModel _calculateViewModel = DemandesViewModel();
  final PinViewModel pinViewModel = PinViewModel();

  late final List<Map<String, dynamic>> _paymentInfoFields = [
    {'key': 'id_institution_financiere', 'label': 'Numéro Institution Bancaire'},
    {'key': 'banque', 'label': 'Nom Banque'},
    {'key': 'swift', 'label': 'Code Swift'},
    {'key': 'iban', 'label': 'Numéro Iban'},
    {'key': 'id_compte', 'label': 'Numéro Compte'},
    {'key': 'emailBeneficiaire', 'label': 'Addresse Email'},
    {'key': 'id_transit', 'label': 'Numéro Transit'},
  ];

  @override
  void dispose() {
    _calculateDebounce?.cancel();
    _fromController.dispose();
    _toController.dispose();
    _searchBeneficiaireController.dispose();
    _promoContoller.dispose();
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.selectedDestination != null) {
      selectedDesinaion = widget.selectedDestination;
    }
    if (widget.paysDestination != null) {
      paysDestinationModel = widget.paysDestination;
    }
    if (widget.modeRetrait != null) {
      selectedModeRetrait = widget.modeRetrait;
    }
    if (widget.motif != null) {
      selectedMotif = widget.motif;
    }
    if (widget.prefilledMotifs != null) {
      motifs = List<MotifModel>.from(widget.prefilledMotifs!);
      loadedMotif = true;
    }

    if (widget.repeatTransferValidated) {
      _applyValidatedRepeatTransferPrefill();
    } else {
      demandesViewModel.myDestinationsApi([], context);
      demandesViewModel2.beneficiaires([], context);
      demandesViewModel3.motifs([], context).then((value) {
        if (mounted) {
          setState(() {
            motifs = value;
            _resolvePrefilledMotif();
          });
        }
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializePageView();
      });
    }

    step = _resolveInitialStep();
    _controller = PageController(initialPage: step);

    UserViewModel().getUser().then((value) {
      if (mounted) {
        setState(() {
          user = value;
        });
      }
    });
  }

  int _resolveInitialStep() {
    if (widget.repeatTransferValidated && widget.beneficiaire != null) {
      return STEP_CONFIRMATION;
    }
    if (widget.beneficiaire != null && !_beneficiaryValidationFailed) {
      return _calculateInitialStep();
    }
    return STEP_BENEFICIARY;
  }

  void _applyValidatedRepeatTransferPrefill() {
    selectedBeneficiaire = widget.beneficiaire;
    selectedDesinaion = widget.selectedDestination;
    paysDestinationModel = widget.paysDestination;
    selectedModeRetrait = widget.modeRetrait;
    selectedMotif = widget.motif;
    loadedDestination = true;
    loadedModeRetrait = true;
    loadedMotif = true;
    initBen = true;

    if (widget.paysDestination != null) {
      demandesViewModel.setPaysDestination(ApiResponse.completed(widget.paysDestination));
    }
    if (widget.prefilledBeneficiaires != null) {
      demandesViewModel2.setBeneficiairesList(
        ApiResponse.completed(widget.prefilledBeneficiaires),
      );
    }

    demandesViewModel.myDestinationsApi([], context).then((freshPaysDestination) {
      if (!mounted || freshPaysDestination == null) return;
      setState(() {
        paysDestinationModel = freshPaysDestination;
        demandesViewModel.setPaysDestination(ApiResponse.completed(freshPaysDestination));
        _resolvePrefilledDestination(freshPaysDestination);
        _resolvePrefilledModeRetrait();
      });
      _requestInitialCalculation(force: true);
    });
  }

  void _requestInitialCalculation({bool force = false}) {
    if (_initialCalculationRequested && !force) return;
    if (widget.amount == null || selectedDesinaion == null) return;

    _initialCalculationRequested = true;
    insert(widget.amount, _fromController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.amount == null) return;
      _requestCalculation(fromSource: true, amount: widget.amount!);
    });
  }

  void _initializePageView() {
    if (widget.beneficiaire != null && !initBen) {
      final stepToGo = _beneficiaryValidationFailed
          ? STEP_BENEFICIARY
          : _calculateInitialStep();

      setState(() {
        step = stepToGo;
        initBen = true;
        selectedBeneficiaire = widget.beneficiaire;
      });
      _controller.jumpToPage(stepToGo);
    }
  }

  int _calculateInitialStep() {
    if (widget.beneficiaire == null) return STEP_BENEFICIARY;

    int stepToGo = STEP_AMOUNT;

    if (selectedModeRetrait != null) {
      stepToGo = STEP_REASON;
      if (selectedMotif != null) {
        stepToGo = STEP_CONFIRMATION;
      }
    }

    return stepToGo;
  }

  BeneficiaireModel? _findBeneficiaryInList(List<dynamic>? data, int? id) {
    if (data == null || id == null) return null;
    for (final item in data) {
      if (item == null) continue;
      final beneficiary = BeneficiaireModel.fromJson(Map<String, dynamic>.from(item));
      if (beneficiary.idBeneficiaire == id) {
        return beneficiary;
      }
    }
    return null;
  }

  void _resolvePrefilledMotif() {
    if (loadedMotif || widget.motif == null || motifs.isEmpty) return;

    MotifModel? resolved;
    for (final motif in motifs) {
      if (motif.idMotif == widget.motif!.idMotif) {
        resolved = motif;
        break;
      }
    }
    selectedMotif = resolved;
    loadedMotif = true;
    _syncStepAfterPrefillResolution();
  }

  void _resolvePrefilledDestination(PaysDestinationModel freshPaysDestination) {
    if (widget.destination == null || freshPaysDestination.destination == null) return;

    for (final element in freshPaysDestination.destination!) {
      if (element.codePaysDest == widget.destination) {
        selectedDesinaion = element;
        break;
      }
    }
  }

  void _resolvePrefilledModeRetrait() {
    if (loadedModeRetrait) return;

    if (widget.modeRetrait == null || selectedDesinaion?.modeRetrait == null) {
      selectedModeRetrait = null;
      loadedModeRetrait = true;
      _syncStepAfterPrefillResolution();
      return;
    }

    final targetId = widget.modeRetrait!.idModeRetrait;
    ModeRetrait? resolved;
    for (final element in selectedDesinaion!.modeRetrait!) {
      if (element.idModeRetrait == targetId) {
        resolved = element;
        break;
      }
    }
    selectedModeRetrait = resolved;
    loadedModeRetrait = true;
    _syncStepAfterPrefillResolution();
  }

  void _syncStepAfterPrefillResolution() {
    if (!initBen || widget.beneficiaire == null || _beneficiaryValidationFailed) return;

    final targetStep = _calculateInitialStep();
    if (targetStep == step) return;

    setState(() {
      step = targetStep;
    });
    _controller.jumpToPage(targetStep);
  }

  void _scheduleInitialCalculation() {
    _requestInitialCalculation();
  }

  void _handleMissingRepeatBeneficiary() {
    if (!widget.repeatFromHistory || _beneficiaryValidationFailed) return;

    _beneficiaryValidationFailed = true;
    Utils.flushBarErrorMessage(
      AppLocalizations.of(context)!.translate('repeat_transfer_beneficiary_invalid'),
      context,
    );

    setState(() {
      selectedBeneficiaire = null;
      step = STEP_BENEFICIARY;
      selectedModeRetrait = null;
      selectedMotif = null;
      _clearCalculation();
      _fromController.clear();
      _toController.clear();
    });
    _controller.jumpToPage(STEP_BENEFICIARY);
  }

  void _validateRepeatBeneficiary(List<dynamic>? beneficiaries) {
    if (widget.repeatTransferValidated) return;
    if (!widget.repeatFromHistory || widget.beneficiaire?.idBeneficiaire == null) return;

    final freshBeneficiary = _findBeneficiaryInList(
      beneficiaries,
      widget.beneficiaire!.idBeneficiaire,
    );

    if (freshBeneficiary == null) {
      _handleMissingRepeatBeneficiary();
      return;
    }

    if (selectedBeneficiaire?.idBeneficiaire != freshBeneficiary.idBeneficiaire) {
      setState(() {
        selectedBeneficiaire = freshBeneficiary;
        selectedDesinaion = freshBeneficiary.destination ?? selectedDesinaion;
      });
    }
  }

  void _onChanged(int index) {
    setState(() {
      step = index;
    });
  }

  void insert(content, TextEditingController controller) {
    if (content.runtimeType.toString() == "double") {
      final decimals = controller == _toController
          ? _decimalsForDestination()
          : _decimalsForSource();
      content = double.parse(content.toStringAsFixed(decimals));
      controller.text = _formatAmount(content, decimals: decimals);
    } else {
      _fromController.clear();
      _toController.clear();
      _clearCalculation();
    }
  }

  int _decimalsForSource() => 2;

  int _decimalsForDestination() {
    final code = selectedDesinaion?.paysCodeMonnaieDest?.toUpperCase();
    if (code == 'XOF' || code == 'XAF') return 0;
    return 2;
  }

  String _formatAmount(double value, {int? decimals}) {
    final d = decimals ?? 2;
    if (d == 0) {
      return value.round().toString();
    }
    final formatted = value.toStringAsFixed(d);
    final dotIndex = formatted.indexOf('.');
    if (dotIndex == -1) return formatted;
    final fraction = formatted.substring(dotIndex + 1);
    if (fraction.replaceAll('0', '').isEmpty) {
      return formatted.substring(0, dotIndex);
    }
    return formatted;
  }

  String _countryCode(String? code) => (code ?? '').toUpperCase();

  void _clearCalculation() {
    _transferCalculation = null;
    _isCalculating = false;
  }

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
    final currency = paysDestinationModel?.paysCodeMonnaieSrce ?? '';
    final calc = _transferCalculation!;
    final frais = calc.feesFixed + calc.feesVariable;
    return '${_formatAmount(frais > 0 ? frais : calc.amountFees)} $currency';
  }

  String _displayTotal() {
    if (_isCalculating || _transferCalculation == null) return '-';
    return '${_formatAmount(_transferCalculation!.amountTotal)} ${paysDestinationModel?.paysCodeMonnaieSrce ?? ''}';
  }

  void _onAmountInputChanged({required bool fromSource, required String value}) {
    if (_isUpdatingControllersFromApi) return;

    if (selectedDesinaion == null) {
      Utils.flushBarErrorMessage(
        AppLocalizations.of(context)!.translate("select_destination_country_first"),
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
        _fromController.clear();
      }
    });

    _calculateDebounce?.cancel();

    final trimmed = value.trim();
    if (trimmed.isEmpty || !isDouble(trimmed)) {
      setState(() {
        _isCalculating = false;
        _clearCalculation();
        if (trimmed.isEmpty) {
          if (fromSource) {
            _toController.clear();
          } else {
            _fromController.clear();
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
    String? promoOverride,
  }) async {
    if (paysDestinationModel == null || selectedDesinaion == null) return;

    final sequence = ++_calculateSequence;

    final codePaysSource = _countryCode(paysDestinationModel!.codePaysSrce);
    final codePaysDestination = _countryCode(selectedDesinaion!.codePaysDest);

    final payload = <String, dynamic>{
      'code_sens': '$codePaysSource-$codePaysDestination',
      'code_pays_source': codePaysSource,
      'code_pays_destination': codePaysDestination,
      'amount_source': fromSource ? amount : 0,
      'amount_destination': fromSource ? 0 : amount,
      'code_promo': promoOverride ?? _promoContoller.text.trim(),
      'amount_with_fee': true,
    };

    final result = await _calculateViewModel.calculateTransfer(context, payload);

    if (!mounted || sequence != _calculateSequence) return;

    if (result == null) {
      setState(() {
        _isCalculating = false;
      });
      return;
    }

    if (!result.isOk) {
      setState(() {
        _isCalculating = false;
      });
      if (result.promoError != null && result.promoError!.isNotEmpty) {
        Utils.flushBarErrorMessage(result.promoError!, context);
      }
      return;
    }

    _applyCalculationResult(result, fromSource: fromSource);
  }

  void _applyCalculationResult(TransferCalculation result, {required bool fromSource}) {
    _isUpdatingControllersFromApi = true;
    _fromController.text = _formatAmount(result.amountYouSend, decimals: _decimalsForSource());
    _toController.text = _formatAmount(result.amountDestination, decimals: _decimalsForDestination());
    _isUpdatingControllersFromApi = false;

    setState(() {
      _transferCalculation = result;
      _isCalculating = false;
      fromToToSens = fromSource;
      if (result.promoApplied) {
        loadingPromoSucces = true;
        promo = true;
        if (result.promoCode != null && result.promoCode!.isNotEmpty) {
          promoCode = result.promoCode!;
        }
        _confettiController.play();
      } else if (result.promoError != null && result.promoError!.isNotEmpty) {
        loadingPromoSucces = false;
        promo = false;
        Utils.flushBarErrorMessage(result.promoError!, context);
      }
    });
  }

  bool isDouble(String value) {
    final doubleNumber = double.tryParse(value);
    return doubleNumber != null;
  }

  String _getStepTitle(BuildContext context) {
    switch (step) {
      case STEP_BENEFICIARY:
        return AppLocalizations.of(context)!.translate("beneficiary");
      case STEP_AMOUNT:
        return AppLocalizations.of(context)!.translate("amount");
      case STEP_REASON:
        return AppLocalizations.of(context)!.translate("transfer_reason_and_method");
      case STEP_CONFIRMATION:
        return AppLocalizations.of(context)!.translate("finish");
      default:
        return "";
    }
  }

  Widget _buildBeneficiaryStep() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 20, top: 20, left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTexts.descriptionText(AppLocalizations.of(context)!.translate("select_beneficiary")),
              const SizedBox(height: 20),
              TextField(
                controller: _searchBeneficiaireController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.translate("search") ?? "Rechercher un bénéficiaire",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchBeneficiaireController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchBeneficiaireController.clear();
                      });
                    },
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.formFieldBorderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.formFieldBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              // const SizedBox(height: 15),
              // RoundedButton(
              //   title: AppLocalizations.of(context)!.translate("new_beneficiary"),
              //   icon: CupertinoIcons.add,
              //   color: AppColors.buttonBlackColor,
              //   textColor: Colors.white,
              //   onPress: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => NewBeneficiaireView(
              //           destination: selectedDesinaion,
              //           parentDemandViewModel: demandesViewModel,
              //           isFromTransfert: true,
              //           onBeneficiaireCreated: (beneficiaire) {
              //             setState(() {
              //               selectedBeneficiaire = beneficiaire;
              //               selectedDesinaion = beneficiaire.destination;
              //             });
              //             demandesViewModel2.beneficiaires([], context);
              //             _controller.nextPage(
              //               duration: const Duration(milliseconds: 300),
              //               curve: Curves.linear,
              //             );
              //           },
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
        Expanded(
          child: ChangeNotifierProvider<DemandesViewModel>.value(
            value: demandesViewModel2,
            child: Consumer<DemandesViewModel>(
              builder: (context, value, _) {
                switch (value.beneficiairesList.status) {
                  case Status.LOADING:
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: const Center(
                        child: CupertinoActivityIndicator(color: Colors.black),
                      ),
                    );
                  case Status.ERROR:
                    return Center(
                      child: Text(value.beneficiairesList.message.toString()),
                    );
                  default:
                    List data = value.beneficiairesList.data!.where((element) => element != null).toList();
                    _validateRepeatBeneficiary(data);

                    if (data.isEmpty) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!.translate("no_beneficiary_registered"),
                          style: TextStyle(color: Colors.black.withOpacity(.2)),
                        ),
                      );
                    }

                    List filteredData = data.where((element) {
                      BeneficiaireModel ben = BeneficiaireModel.fromJson(element);
                      String searchText = _searchBeneficiaireController.text.toLowerCase();
                      return ben.fullName()!.toLowerCase().contains(searchText) ||
                          ben.telBeneficiaire!.toLowerCase().contains(searchText);
                    }).toList();

                    return Column(
                      children: [
                        if (filteredData.isEmpty && _searchBeneficiaireController.text.isNotEmpty)
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off, size: 60, color: Colors.black.withOpacity(.2)),
                                  const SizedBox(height: 10),
                                  Text(
                                    AppLocalizations.of(context)!.translate("no_results_found") ?? "Aucun résultat trouvé",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(.3),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (filteredData.isNotEmpty)
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredData.length,
                              itemBuilder: (context, index) {
                                BeneficiaireModel current = BeneficiaireModel.fromJson(filteredData[index]);

                                return InkWell(
                                  onTap: () {
                                    selectedBeneficiaire = current;
                                    selectedDesinaion = current.destination;

                                    _controller.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.linear,
                                    );
                                  },
                                  child: RecipientCard2(
                                    name: current.fullName(),
                                    address: current.codePays.toString(),
                                    initials: current.initials(),
                                    phone: current.telBeneficiaire.toString(),
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],
                    );
                }
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildAmountStep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: ChangeNotifierProvider<DemandesViewModel>.value(
              value: demandesViewModel,
              child: Consumer<DemandesViewModel>(
                builder: (context, value, _) {
                  switch (value.paysDestination.status) {
                    case Status.LOADING:
                      return SizedBox(
                        height: constraints.maxHeight,
                        child: const Center(
                          child: CupertinoActivityIndicator(color: Colors.black),
                        ),
                      );
                    case Status.ERROR:
                      return SizedBox(
                        height: constraints.maxHeight,
                        child: Center(
                          child: Text(value.paysDestination.message.toString()),
                        ),
                      );
                    default:
                      paysDestinationModel = value.paysDestination.data!;
                      _resolvePrefilledDestination(paysDestinationModel!);

                      if (selectedBeneficiaire == null && widget.beneficiaire != null) {
                        selectedBeneficiaire = widget.beneficiaire;
                      }

                      if (selectedDesinaion == null && widget.selectedDestination != null) {
                        selectedDesinaion = widget.selectedDestination;
                      }

                      if (!loadedDestination) {
                        loadedDestination = true;
                      }

                      _resolvePrefilledModeRetrait();
                      _resolvePrefilledMotif();
                      _scheduleInitialCalculation();

                      return Container(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                          left: 20,
                          right: 20,
                          top: 10,
                        ),
                        child: _buildAmountContent(),
                      );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAmountContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCountryPairDisplay(),
          const SizedBox(height: 10),
          _buildSendAmountField(),
          const SizedBox(height: 10),
          _buildReceiveAmountField(),
          const SizedBox(height: 10),
          if (selectedDesinaion != null && paysDestinationModel != null)
            AppTexts.buttonText(
              _transferCalculation?.formule ??
                  (selectedDesinaion!.rate != null
                      ? "1 ${paysDestinationModel!.paysCodeMonnaieSrce} = ${selectedDesinaion!.rate} ${selectedDesinaion!.paysCodeMonnaieDest}"
                      : AppLocalizations.of(context)!.translate("custom_exchange_rate_info")),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: AppTexts.menuText(AppLocalizations.of(context).translate("custom_exchange_rate_info"))),
            ],
          ),
          const SizedBox(height: 20),
          commonRoundedContainer(
            removePaddingH: true,
            shadow: true,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTexts.smallText(AppLocalizations.of(context)!.translate("you_send")),
                          _isCalculating
                              ? AppTexts.buttonText("- ${paysDestinationModel!.paysCodeMonnaieSrce}")
                              : AppTexts.buttonText("${_displayValue(isSource: true, controllerText: _fromController.text, sendExcludeFees: true)} ${paysDestinationModel!.paysCodeMonnaieSrce}")
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  commonDivider(),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTexts.smallText(AppLocalizations.of(context)!.translate("beneficiary_receives")),
                          _isCalculating
                              ? AppTexts.buttonText("- ${selectedDesinaion == null ? "" : selectedDesinaion!.paysCodeMonnaieDest}")
                              : AppTexts.buttonText("${_displayValue(isSource: false, controllerText: _toController.text)} ${selectedDesinaion == null ? "-" : selectedDesinaion!.paysCodeMonnaieDest}")
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  commonDivider(),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTexts.smallText(AppLocalizations.of(context)!.translate("transfer_fees")),
                          Row(
                            children: [
                              if (_isCalculating)
                                const Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CupertinoActivityIndicator(radius: 7, color: Colors.black54),
                                  ),
                                ),
                              AppTexts.buttonText(_displayFees()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryPairDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (selectedDesinaion != null)
                Image.asset("packages/country_icons/icons/flags/png/${paysDestinationModel!.codePaysSrce}.png", width: 30, height: 15, fit: BoxFit.contain),
              if (selectedDesinaion != null)
                const SizedBox(width: 10),
              AppTexts.smallText(
                selectedDesinaion == null
                    ? AppLocalizations.of(context)!.translate("select_destination_country")
                    : paysDestinationModel!.paysSrce.toString(),
              ),
            ],
          ),
          const SizedBox(width: 5),
          Icon(Icons.arrow_forward, color: AppColors.primaryColor, size: 20),
          const SizedBox(width: 5),
          Row(
            children: [
              if (selectedDesinaion != null)
                Image.asset("packages/country_icons/icons/flags/png/${selectedDesinaion!.codePaysDest}.png", width: 30, height: 15, fit: BoxFit.contain),
              if (selectedDesinaion != null)
                const SizedBox(width: 10),
              AppTexts.smallText(
                selectedDesinaion == null
                    ? AppLocalizations.of(context)!.translate("select_destination_country")
                    : selectedDesinaion!.paysDest.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSendAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTexts.descriptionText(AppLocalizations.of(context)!.translate("you_send")),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.formFieldBorderColor, width: 1.5),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (paysDestinationModel != null)
              Expanded(
                child: TextFormField(
                  controller: _fromController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) => _onAmountInputChanged(fromSource: true, value: value),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _isCalculating && !fromToToSens
                        ? '-'
                        : AppLocalizations.of(context)!.translate("amount_hint"),
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isCalculating && !fromToToSens ? Colors.black26 : Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              if (paysDestinationModel != null)
                AppTexts.buttonText(paysDestinationModel!.paysCodeMonnaieSrce.toString()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReceiveAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTexts.descriptionText(AppLocalizations.of(context)!.translate("beneficiary_receives")),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.formFieldBorderColor, width: 1.5),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (selectedDesinaion != null)
              Expanded(
                child: TextFormField(
                  controller: _toController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) => _onAmountInputChanged(fromSource: false, value: value),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _isCalculating && fromToToSens
                        ? '-'
                        : AppLocalizations.of(context)!.translate("amount_hint"),
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isCalculating && fromToToSens ? Colors.black26 : Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              if (paysDestinationModel != null)
                AppTexts.buttonText(selectedDesinaion == null ? "-" : selectedDesinaion!.paysCodeMonnaieDest.toString()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWithdrawalModeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTexts.descriptionText(AppLocalizations.of(context)!.translate("withdrawal_mode")),
        const SizedBox(height: 5),
        InkWell(
          onTap: () {
            _showWithdrawalModeModal();
          },
          child: Container(
            padding: const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
              border: Border.all(color: AppColors.formFieldBorderColor, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                selectedModeRetrait == null
                    ? Row(
                      children: [
                        AppTexts.cardTitle(AppLocalizations.of(context).translate('withdrawal_method'), bold: false),
                        const SizedBox(width: 5,),
                        AppTexts.bodyText("*", bold: true, color: Colors.red),
                      ],
                    )
                    : AppTexts.bodyText(selectedModeRetrait!.modeRetrait.toString()),
                const Icon(Icons.arrow_drop_down_sharp),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMotifSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTexts.descriptionText(AppLocalizations.of(context)!.translate("reason")),
        const SizedBox(height: 5),
        InkWell(
          onTap: () {
            _showMotifModal();
          },
          child: Container(
            padding: const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
              border: Border.all(color: AppColors.formFieldBorderColor, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                selectedMotif == null
                    ? Row(
                      children: [
                        AppTexts.cardTitle(AppLocalizations.of(context).translate('reason_label'), bold: false),
                        const SizedBox(width: 5,),
                        AppTexts.bodyText("*", bold: true, color: Colors.red),
                      ],
                    )
                    : AppTexts.bodyText(selectedMotif!.motif.toString()),
                const Icon(Icons.arrow_drop_down_sharp),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showWithdrawalModeModal() {
    if (selectedDesinaion == null || selectedDesinaion!.modeRetrait == null) {
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgColor,
      isScrollControlled: true,
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<ModeRetrait> filteredModeReceipt = List.from(selectedDesinaion!.modeRetrait!);

        return StatefulBuilder(
          builder: (context, setStateModal) {
            void filterModeReceipt(String query) {
              setStateModal(() {
                filteredModeReceipt = selectedDesinaion!.modeRetrait!
                    .where((r) => r.modeRetrait.toString().toLowerCase().contains(query.toLowerCase()))
                    .toList();
              });
            }

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTexts.titleText(AppLocalizations.of(context)!.translate('select_mode_receipt')),
                    const SizedBox(height: 10),
                    TextField(
                      controller: searchController,
                      onChanged: filterModeReceipt,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.translate('search'),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: AppColors.formFieldColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.formFieldBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: filteredModeReceipt.isEmpty
                          ? AppTexts.bodyText(
                        AppLocalizations.of(context)!.translate('emptyList'),
                        color: AppColors.textGrey,
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredModeReceipt.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedModeRetrait = filteredModeReceipt[index];
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1, color: AppColors.lightGrey),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(
                                        width: 5,
                                        color: selectedModeRetrait != null &&
                                            selectedModeRetrait!.idModeRetrait == filteredModeReceipt[index].idModeRetrait
                                            ? AppColors.primaryColor
                                            : AppColors.formFieldBorderColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  AppTexts.bodyText(
                                    filteredModeReceipt[index].modeRetrait.toString(),
                                    color: AppColors.textGrey,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
    );
  }

  void _showMotifModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgColor,
      isScrollControlled: true,
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<MotifModel> filteredMotifs = List.from(motifs);

        return StatefulBuilder(
          builder: (context, setStateModal) {
            void filterMotifs(String query) {
              setStateModal(() {
                filteredMotifs = motifs
                    .where((r) => r.motif.toString().toLowerCase().contains(query.toLowerCase()))
                    .toList();
              });
            }

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTexts.titleText(AppLocalizations.of(context)!.translate('select_reason')),
                    const SizedBox(height: 10),
                    TextField(
                      controller: searchController,
                      onChanged: filterMotifs,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.translate('search'),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: AppColors.formFieldColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.formFieldBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: filteredMotifs.isEmpty
                          ? AppTexts.bodyText(
                        AppLocalizations.of(context)!.translate('emptyList'),
                        color: AppColors.textGrey,
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredMotifs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedMotif = filteredMotifs[index];
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1, color: AppColors.lightGrey),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(
                                        width: 5,
                                        color: selectedMotif != null &&
                                            selectedMotif!.idMotif == filteredMotifs[index].idMotif
                                            ? AppColors.primaryColor
                                            : AppColors.formFieldBorderColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  AppTexts.bodyText(
                                    filteredMotifs[index].motif.toString(),
                                    color: AppColors.textGrey,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
    );
  }

  Widget _buildReasonStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildWithdrawalModeSelector(),
          const SizedBox(height: 10),
          _buildMotifSelector()
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    if (paysDestinationModel == null || selectedDesinaion == null) {
      return const SizedBox();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: commonRoundedContainer(
              removePaddingAll: true,
              child: Column(
                children: [
                  if (selectedBeneficiaire != null)
                    ...[
                      _buildConfirmationRow(
                        AppLocalizations.of(context)!.translate("beneficiary"),
                        selectedBeneficiaire!.fullName() ?? "",
                      ),
                      commonDivider(),
                      _buildConfirmationRow(
                        AppLocalizations.of(context)!.translate("phoneNumberHint"),
                        selectedBeneficiaire!.telBeneficiaire ?? "",
                      ),
                      commonDivider(),
                    ],
                  _buildConfirmationRow(
                    AppLocalizations.of(context)!.translate("source"),
                    paysDestinationModel!.paysSrce.toString(),
                  ),
                  commonDivider(),
                  _buildConfirmationRow(
                    AppLocalizations.of(context)!.translate("destination"),
                    selectedDesinaion!.paysDest.toString(),
                  ),
                  commonDivider(),
                  if (_transferCalculation != null)
                  _buildConfirmationRow(
                    AppLocalizations.of(context)!.translate("amount_to_send"),
                    "${_transferCalculation!.amountSource} ${paysDestinationModel!.paysCodeMonnaieSrce}"
                    // "${_displayValue(isSource: true, controllerText: _fromController.text, sendExcludeFees: true)} ${paysDestinationModel!.paysCodeMonnaieSrce}",
                  ),
                  commonDivider(),
                  if (_transferCalculation != null)
                  _buildConfirmationRow(
                    AppLocalizations.of(context)!.translate("amount_to_receive"),
                    "${_transferCalculation!.amountDestination} ${selectedDesinaion!.paysCodeMonnaieDest}",
                  ),
                  commonDivider(),
                  _buildConfirmationRow(
                    AppLocalizations.of(context)!.translate("transfer_fees"),
                    _displayFees(),
                  ),
                  commonDivider(),
                  _buildPromoCodeSection(),
                  if (promoRabais > 0)
                    ...[
                      commonDivider(),
                      _buildConfirmationRow(
                        AppLocalizations.of(context)!.translate("promo_discount"),
                        "- $promoRabais ${paysDestinationModel!.paysCodeMonnaieSrce}",
                      ),
                    ],
                  commonDivider(),
                  if (_transferCalculation != null && !_isCalculating)
                    _buildTotalToPay(),
                  commonDivider(),
                  if (selectedModeRetrait != null)
                    ...[
                      _buildConfirmationRow(
                        AppLocalizations.of(context)!.translate("withdrawal_method"),
                        selectedModeRetrait!.modeRetrait.toString(),
                      ),
                      commonDivider(),
                    ],
                  if (selectedMotif != null)
                    ...[
                      _buildConfirmationRow(
                        AppLocalizations.of(context)!.translate("transfer_reason"),
                        selectedMotif!.motif.toString(),
                      ),
                      commonDivider(),
                    ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildConfirmationRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppTexts.smallText(label),
          AppTexts.bodyText(value, bold: true),
        ],
      ),
    );
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded, color: AppColors.primaryColor, size: 60),
                const SizedBox(height: 15),
                AppTexts.titleText(AppLocalizations.of(context)!.translate("exit_confirmation_title") ?? "Quitter le transfert ?"),
                const SizedBox(height: 10),
                AppTexts.descriptionText(
                  AppLocalizations.of(context)!.translate("exit_confirmation_message") ?? "Êtes-vous sûr de vouloir quitter ? Toutes les informations saisies seront perdues.",
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: RoundedButton(
                        title: AppLocalizations.of(context)!.translate("cancel") ?? "Annuler",
                        color: AppColors.formFieldBorderColor,
                        textColor: Colors.black,
                        onPress: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RoundedButton(
                        title: AppLocalizations.of(context)!.translate("exit") ?? "Quitter",
                        color: Colors.red,
                        textColor: Colors.white,
                        onPress: () {
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Exit SendView
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalToPay() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppTexts.smallText(
            AppLocalizations.of(context)!.translate("total_to_pay"),
            color: AppColors.primaryColor,
          ),
          Row(
            children: [
              AppTexts.titleText(
                _displayTotal(),
                color: AppColors.primaryColor,
              ),
              if (step == STEP_CONFIRMATION)
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(STEP_AMOUNT);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.edit,
                      size: 18,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Colors.black.withOpacity(.02),
            child: SizedBox(
              width: (MediaQuery.of(context).size.width - 55) * 0.7,
              child: TextFormField(
                controller: _promoContoller,
                enabled: !loadingPromoSucces,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  UpperCaseTextFormatter(),
                ],
                decoration: InputDecoration(
                  label: AppTexts.descriptionText(
                    AppLocalizations.of(context)!.translate("promo_code"),
                  ),
                  fillColor: AppColors.formFieldColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: AppColors.formFieldBorderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: AppColors.formFieldBorderColor),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: AppColors.formFieldBorderColor),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: AppColors.formFieldBorderColor),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: AppColors.formFieldBorderColor),
                  ),
                  focusedBorder: InputBorder.none,
                  focusColor: AppColors.primaryColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          InkWell(
            onTap: () => _applyPromoCode(),
            child: Container(
              width: (MediaQuery.of(context).size.width - 55) * 0.3 - 20,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Center(
                child: loadingPromo
                    ? const SizedBox(
                  width: 17,
                  height: 17,
                  child: CupertinoActivityIndicator(color: Colors.white, radius: 10),
                )
                    : loadingPromoSucces
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : AppTexts.smallText(AppLocalizations.of(context)!.translate("apply"), color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _applyPromoCode() async {
    if (_promoContoller.text.isEmpty) {
      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate("promo_code_empty"), context);
      return;
    }
    if (_fromController.text.isEmpty && _toController.text.isEmpty) {
      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate("amount_required"), context);
      return;
    }
    if (_transferCalculation == null || paysDestinationModel == null) {
      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate("amount_required"), context);
      return;
    }

    final enteredPromoCode = _promoContoller.text.trim();
    final amount = _transferCalculation!.amountTotal;

    setState(() {
      loadingPromo = true;
      loadingPromoSucces = false;
      promoCode = enteredPromoCode;
    });

    final promoVm = DemandesViewModel();
    await promoVm.applyPromo(context, {
      "codePromo": enteredPromoCode,
      "code_pays_srce": paysDestinationModel!.codePaysSrce.toString(),
      "montant": amount,
    });
    if (!mounted) return;

    if (promoVm.applyDetail.status != Status.COMPLETED) {
      setState(() => loadingPromo = false);
      return;
    }

    await _requestCalculation(
      fromSource: fromToToSens,
      amount: amount,
      promoOverride: enteredPromoCode,
    );
    if (!mounted) return;

    setState(() => loadingPromo = false);

    if (_transferCalculation?.promoApplied == true) {
      setState(() {
        loadingPromoSucces = true;
        promo = true;
      });
      _promoContoller.clear();
      _confettiController.play();
    }
  }

  void _handleContinueButton() {
    FocusScope.of(context).unfocus();
    if (currentFocus != null) {
      currentFocus!.unfocus();
    }

    if (step == STEP_AMOUNT) {
      _validateAmountStep();
    } else if (step == STEP_REASON) {
      _validateReasonStep();
    } else if (step == STEP_CONFIRMATION) {
      if (_transferCalculation == null || _isCalculating) {
        Utils.flushBarErrorMessage(
          AppLocalizations.of(context)!.translate("enter_amount"),
          context,
        );
        return;
      }
      _submitTransfer();
    }
  }

  void _validateAmountStep() {
    if (selectedDesinaion == null) {
      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate("select_destination_country"), context);
    } else if (_isCalculating) {
      Utils.flushBarErrorMessage(
        AppLocalizations.of(context)!.translate("calculation_in_progress") ?? "Calcul en cours, veuillez patienter…",
        context,
      );
    } else if (_transferCalculation == null || !_transferCalculation!.isOk) {
      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate("enter_amount"), context);
    } else if (_fromController.text.isEmpty && _toController.text.isEmpty) {
      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate("enter_amount"), context);
    } else {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  void _validateReasonStep() {
    if (selectedBeneficiaire == null) {
      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate("select_beneficiary"), context);
      return;
    }
    if (selectedMotif == null) {
      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate("select_reason"), context);
    } else if (selectedModeRetrait == null) {
      Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate("select_withdrawal_method"), context);
    } else {
      Map requiredFields = {};
      if (selectedModeRetrait != null) {
        List modeRetraitFields = selectedModeRetrait!.withdrawalFieldRequired!.split(",");
        for (var field in modeRetraitFields) {
          if (field != 'telBeneficiaire') {
            if (selectedBeneficiaire!.paymentInfos![field]['value'] == null ||
                selectedBeneficiaire!.paymentInfos![field]['value'] == "") {
              requiredFields[field] = selectedBeneficiaire!.paymentInfos![field]['name'];
            }
          }
        }
      }
      if (requiredFields.isEmpty) {
        _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewBeneficiaireView(
              parentDemandViewModel: demandesViewModel,
              fields: requiredFields,
              beneficiaireModel: selectedBeneficiaire,
              onBeneficiaireCreated: (beneficiaire) {
                setState(() {
                  selectedBeneficiaire = beneficiaire;
                  selectedDesinaion = beneficiaire.destination;
                });
                _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
              },
              updateSuccess: () {
                setState(() {
                  selectedDesinaion = selectedBeneficiaire!.destination;
                  _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
                });
              },
            ),
          ),
        );
      }
    }
  }

  void _submitTransfer({String? pin, bool wallet = false}) {
    if (!loading) {
      if (selectedBeneficiaire == null ||
          selectedDesinaion == null ||
          selectedModeRetrait == null ||
          selectedMotif == null ||
          paysDestinationModel == null ||
          _transferCalculation == null ||
          _isCalculating) {
        Utils.flushBarErrorMessage(
          AppLocalizations.of(context)!.translate("enter_amount"),
          context,
        );
        return;
      }

      setState(() {
        loading = true;
      });

      final calc = _transferCalculation!;
      final fromAmount = calc.amountSource;
      final toAmount = calc.amountDestination;
      final fees = calc.feesFixed + calc.feesVariable;
      final fromAmountWithFees = fromAmount + fees;

      Map<String, dynamic> data2 = {
        "code_pays_srce": paysDestinationModel!.codePaysSrce,
        "code_pays_dest": selectedDesinaion!.codePaysDest,

        "montant_srce": double.parse(fromAmountWithFees.toString()),
        "montant_dest": double.parse(toAmount.toString()),

        "id_beneficiaire": selectedBeneficiaire!.idBeneficiaire,
        "id_mode_retrait": selectedModeRetrait!.idModeRetrait,
        "id_motif": selectedMotif!.idMotif,

        "code_promo": promoCode ?? "",

        "amount_with_fee": true,

        if (pin != null) "code_pin": pin,
      };

      demandesViewModel3.transfert(
        data2,
        context,
        transfer: paysDestinationModel!.codePaysSrce != "cd",
        wallet: wallet,
      ).then((value) {
        if (mounted) {
          setState(() {
            loading = false;
          });
          if (paysDestinationModel!.codePaysSrce == "cd") {
            Navigator.pushNamed(context, RoutesName.drcPayment, arguments: {
              'idDemande': value['data']['id_demande'],
              'nomBeneficiaire': value['data']['beneficiaire'],
              'montant': "${_formatAmount(calc.amountTotal)} ${paysDestinationModel!.paysCodeMonnaieSrce}",
            });
          }
        }
      });
    }
  }

  void _showWalletPinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String? pin;
        return Dialog(
          backgroundColor: AppColors.bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline_rounded, color: AppColors.buttonBlackColor, size: 60),
                AppTexts.titleText(AppLocalizations.of(context).translate("PIN_code")),
                AppTexts.descriptionText(AppLocalizations.of(context).translate("wallet_transactions_protected_by_pin")),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        pinViewModel.resetPin(context);
                      },
                      child: AppTexts.bodyText("Code PIN oublié ?", bold: true),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                PinCodeTextField(
                  length: 5,
                  obscureText: true,
                  animationType: AnimationType.fade,
                  animationDuration: const Duration(milliseconds: 300),
                  keyboardType: TextInputType.number,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  cursorColor: Colors.black,
                  showCursor: true,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 50,
                    fieldWidth: 50,
                    errorBorderColor: Colors.black45,
                    inactiveColor: AppColors.formFieldBorderColor,
                    activeColor: AppColors.textGrey,
                    selectedColor: AppColors.textGrey,
                  ),
                  onChanged: (value) {
                    pin = value;
                  },
                  appContext: context,
                ),
                if (!loading)
                  Row(
                    children: [
                      RoundedButton(
                        loading: loading,
                        title: AppLocalizations.of(context)!.translate("validate"),
                        onPress: () async {
                          if (pin == null || pin!.isEmpty) {
                            Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate("enter_pin"), context);
                          } else {
                            Navigator.pop(context);
                            _submitTransfer(pin: pin, wallet: true);
                          }
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          RoundedButton(
            onPress: _handleContinueButton,
            title: step < STEP_CONFIRMATION
                ? AppLocalizations.of(context)!.translate("continue")
                : AppLocalizations.of(context)!.translate("confirm_and_pay"),
            loading: loading,
            icon: Icons.arrow_forward,
            // small: step == STEP_CONFIRMATION && user!.wallet == true,
          ),
          if (step == STEP_CONFIRMATION) const SizedBox(height: 5),
          if (step == STEP_CONFIRMATION && user != null && user!.wallet == true)
            RoundedButton(
              color: AppColors.buttonBlackColor,
              textColor: Colors.white,
              // small: true,
              icon: Icons.wallet_outlined,
              onPress: () => _showWalletPinDialog(context),
              title: AppLocalizations.of(context)!.translate("with_wallet"),
              loading: loading,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildBeneficiaryStep(),
      _buildAmountStep(),
      _buildReasonStep(),
      _buildConfirmationStep(),
    ];

    return HideKeyBordContainer(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: CommonAppBar(
          context: context,
          backArrow: true,
          backClick: () {
            if (step > STEP_BENEFICIARY) {
              _controller.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
            } else {
              Navigator.pop(context);
            }
          },
          actions: step == STEP_BENEFICIARY ?
              [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewBeneficiaireView(
                          destination: selectedDesinaion,
                          parentDemandViewModel: demandesViewModel,
                          isFromTransfert: true,
                          onBeneficiaireCreated: (beneficiaire) {
                            setState(() {
                              selectedBeneficiaire = beneficiaire;
                              selectedDesinaion = beneficiaire.destination;
                            });
                            demandesViewModel2.beneficiaires([], context);
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.linear,
                            );
                          },
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.add_circle_rounded, color: AppColors.primaryColor,),
                )
              ]
              : [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: _showExitConfirmationDialog,
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center(child: Image.asset("assets/logo_black.png", width: 25)),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.formFieldBorderColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 15),
                width: MediaQuery.of(context).size.width,
                height: 5,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (1 / steps) * (step + 1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                child: AppTexts.buttonText(_getStepTitle(context), color: AppColors.primaryColor),
              ),
              Expanded(
                child: Stack(
                  children: [
                    if (step == STEP_CONFIRMATION)
                      Align(
                        alignment: Alignment.topCenter,
                        child: ConfettiWidget(
                          confettiController: _confettiController,
                          blastDirectionality: BlastDirectionality.explosive,
                          shouldLoop: false,
                          colors: [
                            AppColors.primaryColor,
                            Colors.green,
                            Colors.amber,
                            Colors.blue,
                          ],
                        ),
                      ),
                    PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _controller,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pages.length,
                      onPageChanged: _onChanged,
                      itemBuilder: (context, int index) {
                        return pages[index];
                      },
                    ),
                    if (step != STEP_BENEFICIARY)
                      Positioned(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        child: _buildBottomActions(context),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
