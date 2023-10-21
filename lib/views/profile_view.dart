import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/pays_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/appbar_drawer.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
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
  void initState() async {
    super.initState();
    preferences = await SharedPreferences.getInstance();
    bool? lAuth;
    if (preferences != null) {
      lAuth = preferences!.getBool('local_auth');
    }
    setState(() {
      localAuthEnabled = lAuth == true;
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

  @override
  Widget build(BuildContext context) {
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    return Scaffold(
        appBar: CustomAppBar(
          showBack: true,
          title: "Profil",
          backUrl: RoutesName.home,
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: ChangeNotifierProvider<DemandesViewModel>(
            create: (BuildContext context) => demandesViewModel,
            child: Consumer<DemandesViewModel>(
                builder: (context, value, _){
                  switch (value.paysActifList.status) {
                    case Status.LOADING:
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 200,
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors.primaryColor,),
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
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Column(
                                    children: [
                                      if (user != null)
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
                                      const SizedBox(height: 10,),
                                      InkWell(
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
                                                        padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 10),
                                                        decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius: BorderRadius.circular(30),
                                                        ),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: const [
                                                              Icon(Icons.image, color: Colors.white,),
                                                              SizedBox(width: 20,),
                                                              Text("Importer de la gallerie", style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 14
                                                              ),)
                                                            ],
                                                          ),
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
                                                        padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 10),
                                                        decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius: BorderRadius.circular(30),
                                                        ),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: const [
                                                              Icon(Icons.camera_alt, color: Colors.white,),
                                                              SizedBox(width: 20,),
                                                              Text("Prendre une photo", style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 14
                                                              ),)
                                                            ],
                                                          ),
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
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.black
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.edit, color: Colors.white, size: 15,),
                                              SizedBox(width: 5,),
                                              Text("Modifier la photo", style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white
                                              ),)
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20,),
                                      if (user != null)
                                        Text("${user!.prenomClient} ${user!.nomClient}", style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18
                                        ),),
                                      if (user != null)
                                        Text(user!.emailClient.toString(), style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black.withOpacity(.6)
                                        ),),
                                      const SizedBox(height: 10,),
                                      Container(
                                        padding: const EdgeInsets.only(left: 15, right: 5),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          borderRadius: BorderRadius.circular(30)
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text("Connexion avec Face ID", style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12
                                            ),),
                                            Switch(
                                              value: localAuthEnabled, //set true to enable switch by default
                                              onChanged: (bool value) {
                                                localAuthEnabled = value;
                                                if (preferences != null) {
                                                  preferences!.setBool('local_auth', value);
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                color: Colors.black.withOpacity(.07),
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("INFORMATIONS PERSONNELLES", style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(.5)
                                    ),),
                                    InkWell(
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
                                                    const Text("Modifier les informations personnelles", style: TextStyle(
                                                        fontWeight: FontWeight.w600
                                                    ),),
                                                    const SizedBox(height: 20,),
                                                    CustomFormField(
                                                        label: "Adresse",
                                                        controller: _adresseController,
                                                        hint: "Entrez votre adresse",
                                                        password: false
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
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, color: AppColors.primaryColor, size: 14,),
                                          const SizedBox(width: 5,),
                                          Text("Modifier", style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500
                                          ),)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Text("Noms", style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(.6)
                              ),),
                              const SizedBox(height: 5,),
                              if (user != null)
                                Text("${user!.prenomClient} ${user!.nomClient}", style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600
                                ),),
                              const SizedBox(height: 5,),
                              const Divider(),
                              const SizedBox(height: 5,),
                              Text("Adresse", style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(.6)
                              ),),
                              const SizedBox(height: 5,),
                              Text(user!.adresse != null && user!.adresse != 'null' ? user!.adresse.toString(): "_", style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600
                              ),),
                              if (user!.soldeParrainage != null && user!.soldeParrainage != 'null')
                              const SizedBox(height: 5,),
                              if (user!.soldeParrainage != null && user!.soldeParrainage != 'null')
                              const Divider(),
                              if (user!.soldeParrainage != null && user!.soldeParrainage != 'null')
                              const SizedBox(height: 5,),
                              if (user!.soldeParrainage != null && user!.soldeParrainage != 'null')
                              Text("Solde Parrainage", style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(.6)
                              ),),
                              if (user!.soldeParrainage != null && user!.soldeParrainage != 'null')
                              const SizedBox(height: 5,),
                              if (user!.soldeParrainage != null && user!.soldeParrainage != 'null')
                              Text("${user!.soldeParrainage} ${user!.paysMonnaie ?? ''}", style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600
                              ),),
                              const SizedBox(height: 20,),
                              Container(
                                color: Colors.black.withOpacity(.07),
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("STATUT DU COMPTE", style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(.5)
                                    ),),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle_sharp, color: Colors.white, size: 20,),
                                    SizedBox(width: 10,),
                                    Text("Activé", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),)
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                color: Colors.black.withOpacity(.07),
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("CODE DE PARRAINAGE", style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(.5)
                                    ),),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                              if (user != null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(user!.codeParrainage.toString(), style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600
                                    ),),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          builder: (context) {
                                            return Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text("Partager votre code de parrainage", style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                  ),),
                                                  const SizedBox(height: 15,),
                                                  InkWell(
                                                    onTap: () {
                                                      if (user != null && !loadEmail && !loadSMS) {
                                                        setState(() {
                                                          loadEmail = true;
                                                        });
                                                        _openUrl("mailto:?subject=Partage%20du%20code%20de%20parrainage%20ChapChap&body=Voici%20mon%20code%20de%20parrainage%20ChapChap%20%3A%20${user!.codeParrainage}%0AUtilise%20le%20pour%20t%E2%80%99inscrire%20sur%20transfert%20ChapChap%20et%20b%C3%A9n%C3%A9ficie%20de%2010%24%20gratuit");
                                                      }
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                                      decoration: BoxDecoration(
                                                          color: AppColors.primaryColor,
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          if (loadEmail)
                                                          const SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                                          ),
                                                          const SizedBox(width: 10,),
                                                          const Text("Partager par mail", style: TextStyle(
                                                              color: Colors.white
                                                          ),)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 15,),
                                                  InkWell(
                                                    onTap: () {
                                                      if (user != null && !loadEmail && !loadSMS) {
                                                        setState(() {
                                                          loadSMS = true;
                                                        });
                                                        _openUrl("sms:&body=Voici%20mon%20code%20de%20parrainage%20ChapChap%20%3A%20${user!.codeParrainage}%0AUtilise%20le%20pour%20t%E2%80%99inscrire%20sur%20transfert%20ChapChap%20et%20b%C3%A9n%C3%A9ficie%20de%2010%24%20gratuit");
                                                      }
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          if (loadSMS)
                                                          const SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                                          ),
                                                          const SizedBox(width: 10,),
                                                          const Text("Partager par SMS", style: TextStyle(
                                                              color: Colors.white
                                                          ),)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        );
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: const Icon(Icons.share_outlined, size: 15, color: Colors.white,),
                                      ),
                                    )
                                  ],
                                ),
                              const SizedBox(height: 20,),
                              Container(
                                color: Colors.black.withOpacity(.07),
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("ADRESSE ELECTRONIQUE", style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(.5)
                                    ),),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                              if (user != null)
                                Text(user!.emailClient.toString(), style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600
                                ),),
                              const SizedBox(height: 20,),
                              Container(
                                color: Colors.black.withOpacity(.07),
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("NUMÉRO DE TÉLÉPHONE", style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(.5)
                                    ),),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                              if (user != null)
                                Text(user!.telClient.toString(), style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600
                                ),),
                              const SizedBox(height: 20,),
                              Container(
                                color: Colors.black.withOpacity(.07),
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("SÉCURITÉ", style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(.5)
                                    ),),
                                    InkWell(
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
                                                        password: false
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    const Divider(),
                                                    const SizedBox(height: 10,),CustomFormField(
                                                        label: "Nouveau mot de passe",
                                                        controller: _newPasswordController,
                                                        hint: "Nouveau mot de passe",
                                                        password: false
                                                    ),
                                                    const SizedBox(height: 20,),
                                                    CustomFormField(
                                                        label: "Confirmer le Nouveau mot de passe",
                                                        controller: _newPasswordConfirmController,
                                                        hint: "Confirmer le Nouveau mot de passe",
                                                        password: false
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
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, color: AppColors.primaryColor, size: 14,),
                                          SizedBox(width: 5,),
                                          Text("Modifier", style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500
                                          ),)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Text("Mot de passe", style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(.6)
                              ),),
                              const SizedBox(height: 5,),
                              const Text("**************", style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600
                              ),),
                              const SizedBox(height: 20,),
                              Container(
                                color: Colors.black.withOpacity(.07),
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("PAYS DE RESIDENCE", style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(.5)
                                    ),),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text("Séléctionnez le pays", style: TextStyle(
                                                  fontWeight: FontWeight.w600
                                              ),),
                                              const SizedBox(height: 20,),
                                              Expanded(child: ListView.builder(
                                                itemCount: paysActifsList.length,
                                                itemBuilder: (context, index) {
                                                  PaysModel current = PaysModel.fromJson(paysActifsList[index]);
                                                  return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedFrom = current;
                                                          changed = true;
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
                                                            Image.asset("packages/country_icons/icons/flags/png/${current.codePays}.png", width: 20, height: 20, fit: BoxFit.contain,),
                                                            const SizedBox(width: 20,),
                                                            Text(current.paysNom.toString(), style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.bold
                                                            ),)
                                                          ],
                                                        ),
                                                      )
                                                  );
                                                },
                                              ))
                                            ],
                                          )
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
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black.withOpacity(.3), width: 1.5),
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset("packages/country_icons/icons/flags/png/${selectedFrom.codePays}.png", width: 20, height: 15, fit: BoxFit.contain),
                                      const SizedBox(width: 10,),
                                      Text(selectedFrom.paysCodemonnaie.toString(), style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),),
                                      const SizedBox(width: 10,),
                                      const Expanded(child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(Icons.arrow_drop_down),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20,),
                              if (changed)
                              RoundedButton(
                                title: "Enrégistrer",
                                onPress: (){
                                  if (!demandesViewModel.loading) {
                                    Map data = {
                                      'idPays': selectedFrom.idPays,
                                      'adresse': user!.adresse
                                    };
                                    demandesViewModel.uClient(data, context, false);
                                    setState(() {
                                      changed = false;
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      );
                  }
                })
        )



    );
  }
}