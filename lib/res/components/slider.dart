import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:flutter/material.dart';

class SliderPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  Color text_color;

  SliderPage({super.key, required this.title, required this.description, required this.image, Color this.text_color  = Colors.black});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, width: width * 0.6,),
        const SizedBox(height: 60,),
        SizedBox(
          width: 200,
          child: AppTexts.titleText(title)
        ),
        /*Text(title, style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: is_last ? Colors.white: Colors.black
        ),),*/
        const SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: AppTexts.bodyText(description)
        ),
        const SizedBox(height: 60,)
      ],
    );
  }
}