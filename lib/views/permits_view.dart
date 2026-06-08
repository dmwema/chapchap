import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/profile_menu.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PermitView extends StatefulWidget {
  const PermitView({Key? key}) : super(key: key);

  @override
  State<PermitView> createState() => _PermitViewState();
}

class _PermitViewState extends State<PermitView> {
  DemandesViewModel demandesViewModel = DemandesViewModel();

  @override
  void initState() {
    super.initState();
    demandesViewModel.myDemandes([], context, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CommonAppBar(
        context: context,
        backArrow: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTexts.titleText(
                  AppLocalizations.of(context)!.translate('profile.permit'),
                ),
                const SizedBox(height: 20),
          
                // Section Europe
                AppTexts.bodyText(AppLocalizations.of(context)!.translate("europe") , bold: true, color: AppColors.primaryColor),
                const SizedBox(height: 6),
                AppTexts.descriptionText(
                  AppLocalizations.of(context)!.translate("bell_mention"),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  "assets/belmoney.png",
                ),
          
                const SizedBox(height: 10),
          
                Divider(),
                const SizedBox(height: 10),
          
                // Section Canada & Autres
                AppTexts.bodyText(AppLocalizations.of(context)!.translate("canada_autres"), bold: true, color: AppColors.primaryColor),
                const SizedBox(height: 10),
                AppTexts.descriptionText("Permis ESM Transfert ChapChap"),
                const SizedBox(height: 6),
                AppTexts.descriptionText("Revenu Québec : 12497"),
                const SizedBox(height: 6),
                AppTexts.descriptionText("CANAFE : M21202584"),
                const SizedBox(height: 10),
                ProfileMenu(
                  title: AppLocalizations.of(context)!.translate("profile.terms") + " belmoney",
                  icon: Icons.privacy_tip_outlined,
                  noIcon: true,
                  onTap: () async {
                    var urllaunchable = await canLaunch("https://bel.money/terms-and-conditions");
                    if (urllaunchable) {
                      await launch("https://bel.money/terms-and-conditions");
                    } else {
                      Utils.toastMessage("Unable to open terms of use URL");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
