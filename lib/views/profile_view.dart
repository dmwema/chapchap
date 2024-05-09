import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/pays_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/services/image_picker_service.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  TextEditingController _newPasswordConfirmController = TextEditingController();

  PaysModel selectedFrom = PaysModel();
  bool changed = false;
  bool localAuthEnabled = false;
  SharedPreferences? preferences;

  @override
  void initState() {
    super.initState();
    loadPr();
    setState(() {
      AuthViewModel().getLocalAuth().then((value) {
        setState(() {
          localAuthEnabled = value;
        });
      });
    });
    demandesViewModel.paysActifs([], context);
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
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    return Scaffold(
        backgroundColor: AppColors.formFieldColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonAppBar(
                context: context,
                backArrow: true
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Informations personnelles", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black), textAlign: TextAlign.left,),
              ),
              const SizedBox(height: 20,),
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
                              for (var element in paysActifsList) {
                                PaysModel pays = PaysModel.fromJson(element);
                                if (user != null && selectedFrom.idPays == null && (pays.idPays.toString() == user!.idPays.toString())) {
                                  selectedFrom = pays;
                                }
                              }
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                        child: Column(
                                          children: [
                                            if (user != null)
                                              GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      context: context,
                                                      builder: (context) =>  Container(
                                                        padding: const EdgeInsets.all(30),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const SizedBox(height: 20,),
                                                            InkWell(
                                                              child: Container(
                                                                width: MediaQuery.of(context).size.width,
                                                                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 10),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.black,
                                                                  borderRadius: BorderRadius.circular(5),
                                                                ),
                                                                child:  const Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Icon(CupertinoIcons.photo_on_rectangle, color: Colors.white,),
                                                                    SizedBox(width: 10,),
                                                                    Text("Importer de la gallerie", style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 14
                                                                    ),)
                                                                  ],
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                ImagePickerService(
                                                                    source: ImageSource.gallery
                                                                ).piclImage().then((value) {
                                                                  if (value != null) {
                                                                    authViewModel.userImage({"img": value}, context: context);
                                                                    Navigator.pop(context);
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                            const SizedBox(height: 10,),
                                                            InkWell(
                                                              child: Container(
                                                                width: MediaQuery.of(context).size.width,
                                                                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 10),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.black,
                                                                  borderRadius: BorderRadius.circular(5),
                                                                ),
                                                                child: const Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Icon(Icons.camera_alt, color: Colors.white,),
                                                                    SizedBox(width: 10,),
                                                                    Text("Prendre une photo", style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 14
                                                                    ),)
                                                                  ],
                                                                ),
                                                              ),
                                                              onTap: () async {
                                                                await ImagePickerService(source: ImageSource.camera).piclImage().then((value) {
                                                                  if (value != null) {
                                                                    authViewModel.userImage({"img": value}, context: context);
                                                                    Navigator.pop(context);
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.vertical(
                                                            top: Radius.circular(30),
                                                          )
                                                      )
                                                  );
                                                },
                                                child: Stack(
                                                  children: [
                                                    CircularProfileAvatar(
                                                      user!.photoProfil.toString(),
                                                      radius: 30, // sets radius, default 50.0
                                                      initialsText: Text(
                                                        "CC",
                                                        style: TextStyle(fontSize: 16, color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                                                      ),  // sets initials text, set your own style, default Text('')
                                                      elevation: 2.0, // sets elevation (shadow of the profile picture), default value is 0.0
                                                      foregroundColor: Colors.brown.withOpacity(0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                                                      cacheImage: true, // allow widget to cache image against provided url
                                                      showInitialTextAbovePicture: false, // setting it true will show initials text above profile picture, default false
                                                    ),
                                                    Positioned(
                                                      bottom: 1,
                                                      right: 1,
                                                      child: Container(
                                                        width: 20,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: Colors.white
                                                        ),
                                                        child: const Center(
                                                          child: Icon(Icons.edit, size: 12,),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            const SizedBox(height: 10,),
                                            if (user != null)
                                              Text("${user!.prenomClient} ${user!.nomClient}", style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18
                                              ),),
                                            const SizedBox(height: 10,),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(CupertinoIcons.check_mark_circled, color: Colors.white, size: 16,),
                                                  SizedBox(width: 5,),
                                                  Text("Compte actif", style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 12
                                                  ),)
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                    const SizedBox(height: 20,),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                                              child: Container(
                                                padding: const EdgeInsets.all(20),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children:  [
                                                    const Text("Modifier l'adresse", style: TextStyle(
                                                        fontWeight: FontWeight.w600
                                                    ),),
                                                    const SizedBox(height: 20,),
                                                    CustomFormField(
                                                      label: "Adresse",
                                                      controller: _adresseController,
                                                      hint: "Entrez votre adresse",
                                                    ),
                                                    const SizedBox(height: 20,),
                                                    RoundedButton(
                                                      title: "Enrégistrer",
                                                      loading: demandesViewModel.loading,
                                                      onPress: (){
                                                        if (!demandesViewModel.loading) {
                                                          if (_adresseController.text.isEmpty) {
                                                            Utils.flushBarErrorMessage("Vous devez entrer une adresse", context);
                                                          } else {
                                                            setState(() {
                                                              Map data = {
                                                                "idPays": user!.idPays,
                                                                "adresse": _adresseController.text
                                                              };
                                                              demandesViewModel.uClient(data, context, true);
                                                            });
                                                          }
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
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                                bottom: BorderSide(color: AppColors.formFieldBorderColor, width: 1)
                                            )
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const Icon(CupertinoIcons.map, size: 15,),
                                                  const SizedBox(width: 15,),
                                                  Flexible(
                                                    child: Text(user!.adresse != null && user!.adresse != 'null' ? user!.adresse.toString(): "_", style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        color: Colors.black
                                                    ),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            Icon(Icons.edit, color: AppColors.primaryColor, size: 14,)
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                                              child: Container(
                                                padding: const EdgeInsets.all(20),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children:  [
                                                    const Text("Modifier le mot de passe", style: TextStyle(
                                                        fontWeight: FontWeight.w600
                                                    ),),
                                                    const SizedBox(height: 20,),
                                                    CustomFormField(
                                                      label: "Mot de passe actuel",
                                                      hint: "Mot de passe actuel",
                                                      controller: _oldPasswordContoller,
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    CustomFormField(
                                                      label: "Nouveau mot de passe",
                                                      controller: _newPasswordController,
                                                      hint: "Nouveau mot de passe",
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    CustomFormField(
                                                      label: "Confirmer le Nouveau mot de passe",
                                                      controller: _newPasswordConfirmController,
                                                      hint: "Confirmer le Nouveau mot de passe",
                                                    ),

                                                    const SizedBox(height: 20,),
                                                    RoundedButton(
                                                      title: "Enrégistrer",
                                                      onPress: (){
                                                        if (_newPasswordConfirmController.text.isEmpty || _newPasswordController.text.isEmpty || _oldPasswordContoller.text.isEmpty) {
                                                          Utils.flushBarErrorMessage("Tous les champs sont requis", context);
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
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                                bottom: BorderSide(color: AppColors.formFieldBorderColor, width: 1)
                                            )
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Expanded(
                                              child: Row(
                                                children: [
                                                  Icon(CupertinoIcons.lock, size: 15,),
                                                  SizedBox(width: 15,),
                                                  Flexible(
                                                    child: Text("Modifier le mot de passe", style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        color: Colors.black
                                                    ),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            Icon(Icons.edit, color: AppColors.primaryColor, size: 14,)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                              bottom: BorderSide(color: AppColors.formFieldBorderColor, width: 1)
                                          )
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                const Icon(CupertinoIcons.at, size: 15,),
                                                const SizedBox(width: 15,),
                                                Flexible(
                                                  child: Text(user != null ? user!.emailClient.toString() : "", style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black
                                                  ),),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                              bottom: BorderSide(color: AppColors.formFieldBorderColor, width: 1)
                                          )
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                const Icon(CupertinoIcons.phone, size: 15,),
                                                const SizedBox(width: 15,),
                                                Flexible(
                                                  child: Text(user != null ? user!.telClient.toString() : "", style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black
                                                  ),),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                              bottom: BorderSide(color: AppColors.formFieldBorderColor, width: 1)
                                          )
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                const Icon(Icons.work_outline_outlined, size: 15,),
                                                const SizedBox(width: 15,),
                                                Flexible(
                                                  child: Text(user != null && user!.profession != null ? user!.profession.toString() : "-", style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black
                                                  ),),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    if (changed)
                                    RoundedButton(
                                      title: "Enrégistrer",
                                      onPress: (){

                                      },
                                    )
                                  ],
                                ),
                              );
                          }
                        })
                ),
              ),
            ],
          ),
        )



    );
  }
}