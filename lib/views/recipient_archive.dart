import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/recipient_card2.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipientsArchiveView extends StatefulWidget {
  const RecipientsArchiveView({Key? key}) : super(key: key);

  @override
  State<RecipientsArchiveView> createState() => _RecipientsArchiveViewState();
}

class _RecipientsArchiveViewState extends State<RecipientsArchiveView> {
  DemandesViewModel demandesViewModel = DemandesViewModel();

  @override
  void initState() {
    super.initState();
    demandesViewModel.beneficiairesArchive([], context);
  }

  void _showRecipientDetailsModal(BeneficiaireModel beneficiaire) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgColor,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProfileAvatar(
                  "",
                  radius: 25,
                  backgroundColor: AppColors.primaryColor.withOpacity(.4),
                  initialsText: Text(
                    beneficiaire.initials(),
                    style: TextStyle(fontSize: 16, color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                  ),
                  elevation: 2.0,
                  foregroundColor: Colors.brown.withOpacity(0.5),
                  cacheImage: true,
                  showInitialTextAbovePicture: false,
                ),
                const SizedBox(height: 10),
                AppTexts.titleText(AppLocalizations.of(context).translate(beneficiaire.fullName())),
                AppTexts.descriptionText(AppLocalizations.of(context).translate(beneficiaire.telBeneficiaire!)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTexts.smallText(AppLocalizations.of(context)!.translate('country')),
                    Row(
                      children: [
                        Image.asset("packages/country_icons/icons/flags/png/${beneficiaire.codePays}.png", width: 30, height: 15, fit: BoxFit.contain),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    RoundedButton(
                      title: AppLocalizations.of(context)!.translate('unarchive'),
                      onPress: () {
                        _showConfirmationDialog(context, AppLocalizations.of(context)!.translate('confirm_unarchive'), () async {
                          await demandesViewModel.desarchiveRecipient(context, beneficiaire.idBeneficiaire!.toInt()).then((value) {
                            setState(() {
                              demandesViewModel.beneficiairesArchive([], context);
                            });
                          });
                        });
                      },
                      icon: Icons.unarchive_outlined,
                      color: AppColors.buttonBlackColor,
                      textColor: Colors.white,
                    ),
                    RoundedButton(
                      title: AppLocalizations.of(context)!.translate('delete'),
                      onPress: () {
                        _showConfirmationDialog(context, AppLocalizations.of(context)!.translate('confirm_delete'), () async {
                          await demandesViewModel.deleteRecipient(context, beneficiaire.idBeneficiaire!.toInt()).then((value) {
                            setState(() {
                              demandesViewModel.beneficiaires([], context);
                            });
                          });
                        });
                      },
                      icon: CupertinoIcons.delete_solid,
                      color: AppColors.buttonBlackColor,
                      textColor: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(0),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String message, Future<void> Function() onConfirm) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context)!.translate('confirm')),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: Text(AppLocalizations.of(context)!.translate('cancel'), style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(AppLocalizations.of(context)!.translate('confirm'), style: TextStyle(color: AppColors.primaryColor)),
              onPressed: () async {
                Navigator.of(context).pop();
                await onConfirm();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(context: context, backArrow: true),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppTexts.titleText(AppLocalizations.of(context)!.translate('archived_recipients')),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ChangeNotifierProvider<DemandesViewModel>(
                create: (BuildContext context) => demandesViewModel,
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
                        if (value.beneficiairesList.data!.length == 0) {
                          return Center(
                            child: AppTexts.descriptionText(AppLocalizations.of(context)!.translate('no_archived_recipients')),
                          );
                        }
                        return ListView.builder(
                          itemCount: value.beneficiairesList.data!.length,
                          itemBuilder: (context, index) {
                            BeneficiaireModel beneficiaire = BeneficiaireModel.fromJson(value.beneficiairesList.data![index]);
                            return InkWell(
                              onTap: () => _showRecipientDetailsModal(beneficiaire),
                              child: Column(
                                children: [
                                  RecipientCard2(
                                    name: beneficiaire.fullName()!,
                                    address: beneficiaire.codePays.toString(),
                                    phone: beneficiaire.telBeneficiaire.toString(),
                                    initials: beneficiaire.initials(),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
