import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  final String date;
  final bool sent;
  final String receiver;
  final double amount;

  const HistoryCard({super.key, required this.date, required this.sent, required this.receiver, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.6 - 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(date, style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),),
              const SizedBox(height: 7,),
              Text("$date Envoi argent à $receiver", style: TextStyle(
                  color: Colors.black.withOpacity(.5),
                  fontSize: 12
              ),)
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4 - 30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount.toString(), style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20
              ),),
              const SizedBox(height: 5,),
              Text(sent ? "Réçu": "En cours", style: TextStyle(
                  color: sent ? Colors.green: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 11
              ),)
            ],
          ),
        )
      ],
    );
  }
}