import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

class AppbarDrawer extends StatefulWidget {
  const AppbarDrawer({Key? key}) : super(key: key);

  @override
  State<AppbarDrawer> createState() => _AppbarDrawerState();
}

class _AppbarDrawerState extends State<AppbarDrawer> {
  UserModel? user;

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
            Column(
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
            )
          ],
        ),
      )
    );
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
                    Text(user!.codeParrainage.toString(), style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      color: AppColors.primaryColor
                    ),)
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