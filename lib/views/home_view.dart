import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/appbar_drawer.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/history_card.dart';
import 'package:chapchap/res/components/home_card.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
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
      drawer: AppbarDrawer(),
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
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.send);
                      },
                    ),
                    SizedBox(height: 20,),
                    HomeCard(h: 90, color: AppColors.darkRed2, icon: Icons.bar_chart, title: "Bénéficiaires", onTap: (){
                      Navigator.pushNamed(context, RoutesName.recipeints);
                    },)
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  children: [
                    HomeCard(h: 90, color: AppColors.darkRed, icon: Icons.compare_arrows_rounded, title: "Taux de change", onTap: () {
                      Navigator.pushNamed(context, RoutesName.exchange);
                    },),
                    const SizedBox(height: 20,),
                    HomeCard(
                      h: 150,
                      color: AppColors.marronRed,
                      icon: Icons.history_rounded,
                      title: "Historique des transferts",
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.history);
                      },
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
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: const [
                  HistoryCard(date: "05 Oct 2022", sent: false, receiver: "Daniel Mwema (cd)", amount: 250),
                  SizedBox(height: 5,),
                  Divider(),
                  HistoryCard(date: "05 Oct 2022", sent: false, receiver: "Daniel Mwema (cd)", amount: 250),
                  SizedBox(height: 5,),
                  Divider(),
                  HistoryCard(date: "05 Oct 2022", sent: false, receiver: "Daniel Mwema (cd)", amount: 250),
                  SizedBox(height: 5,),
                  Divider(),
                  HistoryCard(date: "05 Oct 2022", sent: false, receiver: "Daniel Mwema (cd)", amount: 250),
                  SizedBox(height: 5,),
                ],
              ),
            ))
          ],
        ),
      )
    );
  }
}