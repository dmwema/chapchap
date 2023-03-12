import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/appbar_drawer.dart';
import 'package:chapchap/res/components/country_select_modal.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/history_card.dart';
import 'package:chapchap/res/components/payment_methods_modal.dart';
import 'package:chapchap/res/components/recipient_card.dart';
import 'package:chapchap/res/components/recipient_card2.dart';
import 'package:chapchap/res/components/send_bottom_modal.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  UserModel? user;
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
          title: "Profile",
        ),
        drawer: const AppbarDrawer(),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
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
                    ],
                  )
                ),
                SizedBox(height: 20,),
                Container(
                  color: Colors.black.withOpacity(.07),
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("INFORMATIONS PERSONNELLES", style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(.5)
                      ),),
                      Row(
                        children: [
                          Icon(Icons.edit, color: AppColors.primaryColor, size: 14,),
                          SizedBox(width: 5,),
                          Text("Modifier", style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500
                          ),)
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Text("Noms", style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(.6)
                ),),
                const SizedBox(height: 5,),
                if (user != null)
                Text("${user!.prenomClient} ${user!.nomClient}", style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600
                ),),
                const SizedBox(height: 5,),
                Divider(),
                const SizedBox(height: 5,),
                SizedBox(height: 20,),
                Text("Date de naissance", style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(.6)
                ),),
                const SizedBox(height: 5,),
                if (user != null)
                const Text("-", style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600
                ),),
                const SizedBox(height: 5,),
                Divider(),
                const SizedBox(height: 5,),
                SizedBox(height: 20,),
                Text("Adresse", style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(.6)
                ),),
                const SizedBox(height: 5,),
                const Text("-", style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600
                ),),
                SizedBox(height: 20,),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
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
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ADRESSE ELECTRONIQUE", style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(.5)
                      ),),
                      Row(
                        children: [
                          Icon(Icons.edit, color: AppColors.primaryColor, size: 14,),
                          const SizedBox(width: 5,),
                          Text("Modifier", style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500
                          ),)
                        ],
                      )
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
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
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
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("NUMÉRO DE TÉLÉPHONE", style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(.5)
                      ),),
                      Row(
                        children: [
                          Icon(Icons.edit, color: AppColors.primaryColor, size: 14,),
                          SizedBox(width: 5,),
                          Text("Modifier", style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500
                          ),)
                        ],
                      )
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
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("SÉCURITÉ", style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(.5)
                      ),),
                      Row(
                        children: [
                          Icon(Icons.edit, color: AppColors.primaryColor, size: 14,),
                          SizedBox(width: 5,),
                          Text("Modifier", style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500
                          ),)
                        ],
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
              ],
            ),
          ),
        )
    );
  }
}