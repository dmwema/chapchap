import 'package:mardona/res/app_colors.dart';
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
      children: [
        Container(
          width: width - 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), // Ajustez la valeur pour le radius
            border: Border.all(
              color: AppColors.borderGreyColor, // Couleur de la bordure
              width: 3, // Épaisseur de la bordure
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15), // Assurez-vous que l'image a le même radius
            child: Image.asset(
              image,
              width: width - 40,
              fit: BoxFit.cover, // Ajustez l'image pour couvrir l'espace
            ),
          ),
        ),
        const SizedBox(height: 10,),
        Text(title, style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black
        ), textAlign: TextAlign.left,),
        /*Text(title, style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: is_last ? Colors.white: Colors.black
        ),),*/
        const SizedBox(height: 10,),
        Text(description, style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.normal,
            color: AppColors.textGrey
        ), textAlign: TextAlign.left),
        const SizedBox(height: 60,)
      ],
    );
  }
}