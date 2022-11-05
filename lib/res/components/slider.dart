import 'package:chapchap/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SliderPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  Color text_color;

  SliderPage({super.key, required this.title, required this.description, required this.image, Color this.text_color  = Colors.black});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(image, width: width * 0.6,),
          const SizedBox(height: 60,),
          Container(
            width: 200,
            child: Text(title, style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor
            ), textAlign: TextAlign.center,),
          ),
          /*Text(title, style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: is_last ? Colors.white: Colors.black
          ),),*/
          const SizedBox(height: 20,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Text(description, style: TextStyle(
                height: 1.5,
                fontSize: 15, fontWeight: FontWeight.normal, letterSpacing: 0.7,
                color: Colors.black.withOpacity(0.7)
            ), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 60,)
        ],
      ),
    );
  }
}