import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/res/components/profile_menu.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactView extends StatefulWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    UserModel? fetchedUser = await UserViewModel().getUser();
    setState(() {
      user = fetchedUser;
    });
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CommonAppBar(context: context, backArrow: true),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTexts.titleText(AppLocalizations.of(context)!.translate('contactUs')), // Traduction du titre
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ProfileMenu(
                      //   title: "+1 514 370 1555 (Canada)",
                      //   icon: Icons.phone,
                      //   onTap: () => _openUrl("tel://+15143701555"),
                      // ),
                      // ProfileMenu(
                      //   title: "+1 438 492 9679 (Canada)",
                      //   icon: Icons.phone,
                      //   onTap: () => _openUrl("tel://+14384929679"),
                      // ),
                      // ProfileMenu(
                      //   title: "+225 05 74 454 802 (Côte d'Ivoire)",
                      //   icon: Icons.phone,
                      //   onTap: () => _openUrl("tel://+2250574454802"),
                      // ),
                      // ProfileMenu(
                      //   title: "+226 70 06 06 42 (Burkina Faso)",
                      //   icon: Icons.phone,
                      //   onTap: () => _openUrl("tel://+22670060642"),
                      // ),
                      // ProfileMenu(
                      //   title: "+237 6 97 23 09 57 (Cameroun)",
                      //   icon: Icons.phone,
                      //   onTap: () => _openUrl("tel://+237697230957"),
                      // ),
                      ProfileMenu(
                        title: "support@transfertchapchap.com",
                        icon: Icons.alternate_email_sharp,
                        onTap: () => _openUrl("mailto:support@transfertchapchap.com?subject=Contact&body="),
                      ),
                      ProfileMenu(
                        title: "Facebook",
                        icon: Icons.facebook,
                        onTap: () => _openUrl("https://www.facebook.com/Transfertchapchap?mibextid=LQQJ4d"),
                      ),
                      ProfileMenu(
                        title: "Tiktok",
                        icon: Icons.tiktok,
                        onTap: () => _openUrl("https://www.tiktok.com/@transfertchapchap?_t=8kQqzssimJh&_r=1"),
                      ),
                      ProfileMenu(
                        title: "Snapchat",
                        icon: Icons.snapchat,
                        onTap: () => _openUrl("https://t.snapchat.com/iBSGp6MQ"),
                      ),
                      ProfileMenu(
                        title: "WhatsApp",
                        icon: Icons.textsms_outlined,
                        onTap: () => _openUrl("https://wa.me/14384929679"),
                      ),
                      ProfileMenu(
                        title: "Instagram",
                        icon: Icons.photo_camera_back,
                        onTap: () => _openUrl("https://instagram.com/transfertchapchap?igshid=YmMyMTA2M2Y="),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
