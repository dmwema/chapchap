import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipientCard2 extends StatelessWidget {
  final String name;
  final String address;
  final String phone;

  const RecipientCard2({super.key,required this.name, required this.address, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(bottom: 10),
      child: commonRoundedContainer(
        removePaddingV: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              CircularProfileAvatar(
                "",
                radius: 20, // sets radius, default 50.0
                backgroundColor: AppColors.buttonBlackColor, // sets background color, default Colors.white// sets border, default 0.0
                initialsText: Text(
                  getInitials(name),
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),  // sets initials text, set your own style, default Text('')
                elevation: 0, // sets elevation (shadow of the profile picture), default value is 0.0
                foregroundColor: Colors.white, //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                cacheImage: true, // allow widget to cache image against provided url
                showInitialTextAbovePicture: false, // setting it true will show initials text above profile picture, default false
              ),
              const SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTexts.cardTitle(name),
                  const SizedBox(height: 2,),
                  if (phone != "null")
                  AppTexts.cardDescription(phone, color: AppColors.textGrey)
                ],
              ),
              const Expanded(
                child: Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.more_horiz),
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  String getInitials(String name) {
    List<String> nameParts = name.split(" ");

    if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
      return "${nameParts[0][0]}${nameParts[1][0]}";
    } else if (nameParts.length == 1) {
      if (nameParts[0] == "") {
        return "";
      }
      return nameParts[0][0];
    } else {
      return "";
    }
  }
}