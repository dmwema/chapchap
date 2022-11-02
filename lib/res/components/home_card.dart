import 'package:chapchap/res/app_colors.dart';
import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final double h;
  final Color color;
  final IconData icon;
  final title;

  const HomeCard({
    required this.h,
    required this.color,
    required this.icon,
    required this.title
  });

   @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
            width: (MediaQuery.of(context).size.width - 60)  / 2,
            height: h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 40, color: Colors.white,),
                  const SizedBox(height: 5,),
                  Text(title, style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )
        ),
      );
  }
}