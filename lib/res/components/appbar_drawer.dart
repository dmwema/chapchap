import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:url_launcher/url_launcher.dart';

class AppbarDrawer extends StatefulWidget {
  const AppbarDrawer({Key? key}) : super(key: key);

  @override
  State<AppbarDrawer> createState() => _AppbarDrawerState();
}

class _AppbarDrawerState extends State<AppbarDrawer> {
  UserModel? user;

  bool loadEmail = false;
  bool loadSMS = false;

  @override
  void initState() {
    super.initState();
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader (context),
            buildMenuItems (context)
          ],
        ),
      ),
    );
  }

  double? _ratingValue;

  Widget buildHeader (BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
      ),
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircularProfileAvatar(
              "",
              radius: 25, // sets radius, default 50.0
              backgroundColor: AppColors.darkRed , // sets background color, default Colors.white
              borderWidth: 5,  // sets border, default 0.0
              initialsText: Text(
                user != null ? user!.prenomClient.toString()[0] + user!.nomClient.toString()[0]: "",
                style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),  // sets initials text, set your own style, default Text('')
              borderColor: AppColors.darkRed, // sets border color, default Colors.white
              elevation: 5.0, // sets elevation (shadow of the profile picture), default value is 0.0
              foregroundColor: Colors.brown.withOpacity(0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
              cacheImage: true, // allow widget to cache image against provided url
              onTap: () {
                print('adit');
              }, // sets on tap
              showInitialTextAbovePicture: false, // setting it true will show initials text above profile picture, default false
            ),
            const SizedBox(width: 10,),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user != null ? "${user!.prenomClient} ${user!.nomClient}": "",
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(height: 7,),
                Text(
                  user != null ? user!.emailClient.toString(): "",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(.5),
                  ),
                ),
              ],
              ),
            )
          ],
        ),
      )
    );
  }

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
  Widget buildMenuItems (BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        children: [
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text("Accueil"),
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.home);
                },
              ),
              ListTile(
                leading: const Icon(Icons.compare_arrows_outlined),
                title: const Text("Faire un envoi"),
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.send);
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text("Mon historique"),
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.history);
                }
              ),
              ListTile(
                leading: Icon(Icons.bar_chart_rounded),
                title: const Text("Mes bénéficiaires"),
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.recipeints);
                },
              ),
              ListTile(
                leading: Icon(Icons.file_present_outlined),
                title: const Text("Mes factures"),
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.invoices);
                },
              ),
            ],
          ),
          const Divider(),
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text("Mon profil"),
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.profile);
                },
              ),
              ListTile(
                leading: const Icon(Icons.handshake_outlined),
                title: const Text("Mes coupons rabais"),
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.couponView);
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: const Text("Nous joindre"),
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.contactView);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text("Se déconnecter"),
                onTap: () {
                  UserViewModel().remove().then((value) {
                    if (value) {
                      Navigator.pushNamed(context, RoutesName.login);
                    }
                  });
                },
              ),
              const Divider(),
              ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Code de parrainage", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                    ),),
                    const SizedBox(height: 5,),
                    if (user != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(user!.codeParrainage.toString(), style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppColors.primaryColor
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
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.couponView);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}