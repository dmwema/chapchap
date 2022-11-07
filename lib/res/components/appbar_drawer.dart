import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

class AppbarDrawer extends StatefulWidget {
  const AppbarDrawer({Key? key}) : super(key: key);

  @override
  State<AppbarDrawer> createState() => _AppbarDrawerState();
}

class _AppbarDrawerState extends State<AppbarDrawer> {
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
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            CircularProfileAvatar(
              "",
              radius: 25, // sets radius, default 50.0
              backgroundColor: AppColors.darkRed , // sets background color, default Colors.white
              borderWidth: 5,  // sets border, default 0.0
              initialsText: const Text(
                "AS",
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
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
              children: [ const Text(
                "Al-Bakr Sanogo",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(height: 7,),
              Text(
                "albakrsanogo@chapchap.ca",
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
                  Navigator.pushNamed(context, RoutesName.profile);
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
                title: const Text("Mon profile"),
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.profile);
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text("Notifications"),
                onTap: () {
                  //Navigator.pushNamed(context, RoutesName.profile);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text("Se deconnecter"),
                onTap: () {

                },
              ),
            ],
          )
        ],
      ),
    );
  }
}