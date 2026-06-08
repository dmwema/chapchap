import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/l10n/app_localizations.dart';

class PointsHelpView extends StatefulWidget {
  const PointsHelpView({Key? key}) : super(key: key);

  @override
  State<PointsHelpView> createState() => _PointsHelpViewState();
}

class _PointsHelpViewState extends State<PointsHelpView> {
  UserModel? user;

  DemandesViewModel demandesViewModel = DemandesViewModel();

  @override
  Widget build(BuildContext context) {
    return HideKeyBordContainer(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        resizeToAvoidBottomInset: false,
        appBar: CommonAppBar(
          context: context,
          backArrow: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTexts.bigTitleText(AppLocalizations.of(context).translate('how_it_works')),
                const SizedBox(height: 20,),
                AppTexts.titleText(AppLocalizations.of(context).translate('step_1_title')),
                const SizedBox(height: 10,),
                AppTexts.descriptionText(AppLocalizations.of(context).translate('step_1_description_1')),
                const SizedBox(height: 10,),
                AppTexts.descriptionText(AppLocalizations.of(context).translate('step_1_description_2')),
                const SizedBox(height: 20,),
                AppTexts.titleText(AppLocalizations.of(context).translate('step_2_title')),
                const SizedBox(height: 10,),
                AppTexts.descriptionText(AppLocalizations.of(context).translate('step_2_description_1')),
                const SizedBox(height: 10,),
                AppTexts.descriptionText(AppLocalizations.of(context).translate('step_2_description_2')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
