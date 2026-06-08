import 'package:chapchap/res/app_colors.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';

class RecipientCard extends StatelessWidget {
  final bool? active;

  const RecipientCard({super.key, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.lightGrey,
        border: Border.all(color: active! ? AppColors.primaryColor: Colors.black54, width: active! ? 1: 1)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10,),
          const Text("Daniel Mwema", textAlign: TextAlign.center, style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12
          ),),
          const Divider(),
          Text("+243 124 456 789", textAlign: TextAlign.center, style: TextStyle(
            fontSize: 11,
            color: Colors.black.withOpacity(.4),
            fontWeight: FontWeight.w500
          ),),
        ],
      ),
    );
  }
}