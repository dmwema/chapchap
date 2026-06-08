import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/pays_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/profile_info_tile.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/services/image_picker_service.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:chapchap/views/edit_profile_view.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:world_info_plus/world_info_plus.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  DemandesViewModel demandesViewModel = DemandesViewModel();
  AuthViewModel authViewModel = AuthViewModel();
  UserModel? user;
  TextEditingController _adresseController = TextEditingController();
  TextEditingController _oldPasswordContoller = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordConfirmController = TextEditingController();

  PaysModel selectedFrom = PaysModel();
  bool changed = false;
  bool localAuthEnabled = false;
  SharedPreferences? preferences;

  List<Country> allCountries = [];
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    allCountries = WorldInfoPlus.countries;
    loadPr();
    AuthViewModel().getLocalAuth().then((value) {
      if (value) {
        setState(() {
          localAuthEnabled = value;
        });
      }
    });
    demandesViewModel.paysActifs([], context);

    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
        if (user != null && user!.paysNationalite != null) {
            _selectedCountry = allCountries.firstWhere((element) => element.alpha2.toLowerCase() == user!.paysNationalite);
        }
      });
    });

  }

  bool loadEmail = false;
  bool loadSMS = false;

  Future<void> _openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      setState(() {
        loadEmail = false;
        loadSMS = false;
      });
    } else {
      throw 'Could not launch $url';
    }
  }

  Future loadPr() async {
    setState(() async {
      preferences = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CommonAppBar(context: context, backArrow: true),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryColor,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: AppTexts.descriptionText('', color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EditProfileView(user: user)),
          );
        },
      ),
      body: user == null
          ? const Center(child: CupertinoActivityIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircularProfileAvatar(
                    user!.photoProfil ?? "",
                    radius: 45,
                    initialsText: Text(
                      "${user!.prenomClient?[0] ?? ""}${user!.nomClient?[0] ?? ""}",
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppTexts.titleText(
                    "${user!.prenomClient ?? ''} ${user!.nomClient ?? ''}",
                  ),
                  const SizedBox(height: 10),
                  // if (user!.validationCompte == "active")
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.check_mark_circled,
                              color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          AppTexts.descriptionText(t.translate('active_account'),color: Colors.white),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            ProfileInfoTile(
              icon: CupertinoIcons.at,
              label: t.translate('email'),
              value: user!.emailClient ?? "_",
            ),
            ProfileInfoTile(
              icon: CupertinoIcons.phone,
              label: t.translate('phone'),
              value: user!.telClient ?? "_",
            ),
            ProfileInfoTile(
              icon: CupertinoIcons.map,
              label: t.translate('addressLabel'),
              value: user!.adresse ?? "_",
            ),
            ProfileInfoTile(
              icon: CupertinoIcons.location_solid,
              label: t.translate('city'),
              value: user!.villeClient ?? "_",
            ),
            ProfileInfoTile(
              icon: CupertinoIcons.globe,
              label: t.translate('country'),
              value: user!.paysNom ?? "_",
            ),
            ProfileInfoTile(
              icon: CupertinoIcons.person,
              label: t.translate('job'),
              value: user!.profession?.profession ?? "_",
            ),
            if (user != null)
            ProfileInfoTile(
              icon: CupertinoIcons.flag,
              label: t.translate('nationnality'),
              value: user!.paysNationalite == null || user!.paysNationalite == '' || _selectedCountry == null ? '-' : _selectedCountry!.name,
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: AppColors.bgColor,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppTexts.titleText(AppLocalizations.of(context)!.translate('modify_password')),
                            const SizedBox(height: 20),
                            CustomFormField(
                              label: AppLocalizations.of(context)!.translate('current_password'),
                              hint: AppLocalizations.of(context)!.translate('current_password'),
                              controller: _oldPasswordContoller,
                            ),
                            const SizedBox(height: 10),
                            CustomFormField(
                              label: AppLocalizations.of(context)!.translate('new_password'),
                              controller: _newPasswordController,
                              hint: AppLocalizations.of(context)!.translate('new_password'),
                            ),
                            const SizedBox(height: 10),
                            CustomFormField(
                              label: AppLocalizations.of(context)!.translate('confirm_new_password'),
                              controller: _newPasswordConfirmController,
                              hint: AppLocalizations.of(context)!.translate('confirm_new_password'),
                            ),
                            const SizedBox(height: 20),
                            RoundedButton(
                              title: AppLocalizations.of(context)!.translate('save'),
                              onPress: () {
                                if (_newPasswordConfirmController.text.isEmpty || _newPasswordController.text.isEmpty || _oldPasswordContoller.text.isEmpty) {
                                  Utils.flushBarErrorMessage(AppLocalizations.of(context)!.translate('all_fields_required'), context);
                                } else {
                                  Map data = {
                                    "password": _newPasswordController.text,
                                    "password_cfrm": _newPasswordConfirmController.text,
                                    "password_old": _oldPasswordContoller.text
                                  };
                                  authViewModel.uPassword(data, context);
                                }
                              },
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
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: AppColors.formFieldBorderColor, width: 1),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.lock, size: 15),
                          const SizedBox(width: 15),
                          Flexible(
                            child: AppTexts.descriptionText(AppLocalizations.of(context)!.translate('modify_password')),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.edit, color: AppColors.primaryColor, size: 14)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80,)
          ],
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileField({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.formFieldBorderColor)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 10),
          Expanded(child: AppTexts.descriptionText("$label: $value")),
        ],
      ),
    );
  }
}

class BadgeInfo extends StatelessWidget {
  final String title;
  final String value;

  const BadgeInfo({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTexts.smallText(title),
        AppTexts.bodyText(value),
      ],
    );
  }
}
