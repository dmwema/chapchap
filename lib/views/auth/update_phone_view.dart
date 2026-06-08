import 'dart:io';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/pays_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdatePhoneView extends StatefulWidget {
  final Map data;

  const UpdatePhoneView({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<UpdatePhoneView> createState() => _UpdatePhoneViewState();
}

class _UpdatePhoneViewState extends State<UpdatePhoneView> {
  final TextEditingController _phoneController = TextEditingController();

  final DemandesViewModel demandesViewModel = DemandesViewModel();
  final AuthViewModel authViewModel = AuthViewModel();

  List paysList = [];
  PaysModel? selectedPays;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    demandesViewModel.paysActifs([], context);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CommonAppBar(
        context: context,
        backArrow: true,
        backClick: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.login,
                (_) => false,
          );
        },
      ),
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (_) => demandesViewModel,
          child: Consumer<DemandesViewModel>(
            builder: (context, value, _) {
              switch (value.paysActifList.status) {
                case Status.LOADING:
                  return const Center(
                    child: CupertinoActivityIndicator(color: Colors.black),
                  );

                case Status.ERROR:
                  return Center(
                    child: Text(value.paysActifList.message.toString()),
                  );

                default:
                  paysList = value.paysActifList.data!;
                  selectedPays ??= PaysModel.fromJson(paysList.first);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        AppTexts.titleText(loc.providePhoneNumber),
                        const SizedBox(height: 10),
                        AppTexts.descriptionText(
                          loc.phoneNumberDescription,
                        ),

                        const SizedBox(height: 25),
                        Row(
                          children: [
                            AppTexts.smallText(loc.phoneNumber),
                            const SizedBox(width: 5,),
                            AppTexts.bodyText("*", bold: true, color: Colors.red),
                          ],
                        ),

                        InkWell(
                          onTap: _openPaysBottomSheet,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(right: BorderSide(width: 1, color: AppColors.formFieldBorderColor))
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                /// Pays
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.formFieldColor,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: AppColors.formFieldBorderColor, width: 1),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                                  child: Row(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            "packages/country_icons/icons/flags/png/${selectedPays!.codePays}.png",
                                            width: 20,
                                          ),
                                          const SizedBox(width: 6),
                                          const Icon(Icons.arrow_drop_down),
                                        ],
                                      ),

                                      const SizedBox(width: 8),

                                      /// Indicatif
                                      AppTexts.smallText(
                                        selectedPays!.paysIndictel.toString(),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                /// Numéro
                                Expanded(
                                  child: CustomFormField(
                                    label: "",
                                    required: false,
                                    hint: loc.phone,
                                    controller: _phoneController,
                                    type: TextInputType.phone,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        /// === BOUTON ===
                        RoundedButton(
                          title: loc.submit,
                          loading: loading,
                          onPress: _submit,
                        ),
                      ],
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  /// =======================
  /// BottomSheet pays
  /// =======================
  void _openPaysBottomSheet() {
    final loc = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTexts.titleText(loc.selectYourCountry),
              const SizedBox(height: 20),

              SizedBox(
                height: 400,
                child: ListView.builder(
                  itemCount: paysList.length,
                  itemBuilder: (context, index) {
                    final current =
                    PaysModel.fromJson(paysList[index]);

                    return ListTile(
                      leading: Image.asset(
                        "packages/country_icons/icons/flags/png/${current.codePays}.png",
                        width: 24,
                      ),
                      title: AppTexts.smallText(
                        "${current.paysNom} (${current.paysIndictel})",
                      ),
                      onTap: () {
                        setState(() {
                          selectedPays = current;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// =======================
  /// Submit
  /// =======================
  Future<void> _submit() async {
    final loc = AppLocalizations.of(context);

    if (loading) return;

    if (_phoneController.text.isEmpty) {
      Utils.flushBarErrorMessage(
        loc.enterPhoneNumber,
        context,
      );
      return;
    }

    setState(() => loading = true);

    final data = {
      'telephone':
      '${selectedPays!.paysIndictel}${_phoneController.text}',
      'username': widget.data['email'],
    };

    await authViewModel.updatePhone(
      data,
      context,
      widget.data['token'],
    );

    setState(() => loading = false);
  }
}
