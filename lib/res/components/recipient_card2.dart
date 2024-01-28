import 'package:chapchap/res/app_colors.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';

class RecipientCard2 extends StatelessWidget {
  final String name;
  final String address;
  final String phone;

  const RecipientCard2({super.key,required this.name, required this.address, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.formFieldBorderColor, width: 1)
          )
      ),
      child: Row(
        children: [
          CircularProfileAvatar(
            "",
            radius: 20, // sets radius, default 50.0
            backgroundColor: AppColors.primaryColor.withOpacity(.4), // sets background color, default Colors.white// sets border, default 0.0
            initialsText: Text(
              name.split(" ").length > 2 && name.split(" ")[1] != "" ? (name.split(" ")[0][0] + name.split(" ")[1][0]).toString() : name.split(" ")[0][0].toString(),
              style: TextStyle(fontSize: 16, color: AppColors.primaryColor, fontWeight: FontWeight.bold),
            ),  // sets initials text, set your own style, default Text('')
            elevation: 2.0, // sets elevation (shadow of the profile picture), default value is 0.0
            foregroundColor: Colors.brown.withOpacity(0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
            cacheImage: true, // allow widget to cache image against provided url
            showInitialTextAbovePicture: false, // setting it true will show initials text above profile picture, default false
          ),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name, style: const TextStyle(
                  fontWeight: FontWeight.w600
              ),),
              const SizedBox(width: 5,),
              const SizedBox(height: 5,),
              if (address != "null")
              Text(phone, style: const TextStyle(
                fontSize: 11,fontWeight: FontWeight.w500
              ),),
            ],
          ),
          Expanded(
            child: Align(
            alignment: Alignment.centerRight,
            child: Image.asset("packages/country_icons/icons/flags/png/$address.png", width: 30, height: 13, fit: BoxFit.contain),
            )
          )
        ],
      ),
    );
  }
}