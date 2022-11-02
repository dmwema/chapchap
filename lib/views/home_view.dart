import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
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
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Salut!", style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(.5)
            ),),
            const Text("Al-Bakr Sanogo", style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black
            ),),
            SizedBox(height: 20,),
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
            ),
            SizedBox(height: 40,),
            const Text("Dernières opérations", style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black
            ),),
            SizedBox(height: 20,),
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6 - 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("05 Oct 2022", style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),),
                            SizedBox(height: 5,),
                            Text("5 Oct. 2022 Envoi argent à Daniel Mwema (cd)", style: TextStyle(
                                color: Colors.black.withOpacity(.5),
                                fontSize: 11
                            ),)
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}