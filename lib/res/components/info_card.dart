import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.black54)
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(30)
            ),
            width: 30,
            height: 30,
            child: Icon(icon, color: Colors.white, size: 20,)
          ),
          const SizedBox(width: 10,),
          Flexible(child: Text(content,
            style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600
            ),
          ))
        ],
      ),
    );
  }
}