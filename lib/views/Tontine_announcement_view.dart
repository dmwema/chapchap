import 'package:flutter/material.dart';
import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/l10n/app_localizations.dart';

class TontineAnnouncementView extends StatelessWidget {
  const TontineAnnouncementView({Key? key}) : super(key: key);

  Widget sectionTitle(BuildContext context, String key) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        AppLocalizations.of(context).translate(key),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget sectionContent(BuildContext context, String key) {
    return Text(
      AppLocalizations.of(context).translate(key),
      style: const TextStyle(fontSize: 15, height: 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CommonAppBar(context: context, backArrow: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                children: [
                  const Text("💰 ", style: TextStyle(fontSize: 28)),
                  AppTexts.titleText(AppLocalizations.of(context).translate('tontine_title')),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                AppLocalizations.of(context).translate('tontine_subtitle'),
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),

              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/save.jpg',
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),

              sectionTitle(context, 'how_it_works_title'),
              sectionContent(context, 'how_it_works_content'),

              sectionTitle(context, 'security_title'),
              sectionContent(context, 'security_content'),

              sectionTitle(context, 'management_title'),
              sectionContent(context, 'management_content'),

              sectionTitle(context, 'benefits_title'),
              sectionContent(context, 'benefits_content'),

              sectionTitle(context, 'availability_title'),
              sectionContent(context, 'availability_content'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
