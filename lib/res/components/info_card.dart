import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';

class InfoCard extends StatelessWidget {
  final String type;
  final String content;

  const InfoCard({required this.type, required this.content});
  @override
  Widget build(BuildContext context) {
    Color color = Colors.black;

    if (type == "PROMO") {
      color = Colors.green;
    } else if (type == "INFO") {
       color = Colors.orange;
    } else if (type == "DANGER") {
      color = Colors.red;
    }

    IconData icon = Icons.error_outline_rounded;

    if (type == "PROMO") {
      icon = CupertinoIcons.gift;
    } else if (type == "INFO") {
      icon = CupertinoIcons.info;
    } else if (type == "DANGER") {
      icon = CupertinoIcons.exclamationmark_circle;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: type == "PROMO" ? Colors.green : (type == "INFO" ? Colors.orange : AppColors.primaryColor))
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: type == "PROMO" ? Colors.green : (type == "INFO" ? Colors.orange : AppColors.primaryColor),
              borderRadius: BorderRadius.circular(50),
            ),
            width: 60,
            height: 60,
            child: Icon(icon, color: Colors.white, size: 40,)
          ),
          const SizedBox(width: 10,),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type == "PROMO" ? "Promotion": (type == "INFO" ? "Information": "Alert"),
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Flexible(child: Text(content,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}