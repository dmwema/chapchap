import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/home_card.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Salut"),
            Text("Al-Bakr Sanogo"),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    HomeCard(
                      h: 150,
                      color: AppColors.primaryColor,
                      icon: Icons.payment_rounded,
                      title: "Envoi d'argent",
                    ),
                    SizedBox(height: 20,),
                    HomeCard(h: 90, color: AppColors.darkRed2, icon: Icons.bar_chart, title: "Bénéficiaires")
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  children: [
                    HomeCard(h: 90, color: AppColors.darkRed, icon: Icons.compare_arrows_rounded, title: "Taux de change"),
                    SizedBox(height: 20,),
                    HomeCard(
                      h: 150,
                      color: AppColors.marronRed,
                      icon: Icons.history_rounded,
                      title: "Historique des transferts",
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      )
    );
  }
}