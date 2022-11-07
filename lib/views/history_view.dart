import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/appbar_drawer.dart';
import 'package:chapchap/res/components/country_select_modal.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/history_card.dart';
import 'package:chapchap/res/components/payment_methods_modal.dart';
import 'package:chapchap/res/components/recipient_card.dart';
import 'package:chapchap/res/components/send_bottom_modal.dart';
import 'package:flutter/material.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          showBack: true,
          title: 'Historique',
        ),
        drawer: const AppbarDrawer(),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Cette année", style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor.withOpacity(.3)
                ),),
                SizedBox(height: 5,),
                HistoryCard(date: "05 Oct 2022", sent: false, receiver: "Daniel Mwema (cd)", amount: 250),
                SizedBox(height: 5,),
                Divider(),
                HistoryCard(date: "05 Oct 2022", sent: false, receiver: "Daniel Mwema (cd)", amount: 250),
                SizedBox(height: 20,),
                Text("2021", style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor.withOpacity(.3)
                ),),
                HistoryCard(date: "05 Oct 2022", sent: false, receiver: "Daniel Mwema (cd)", amount: 250),
                SizedBox(height: 5,),
                Divider(),
                HistoryCard(date: "05 Oct 2022", sent: false, receiver: "Daniel Mwema (cd)", amount: 250),
                SizedBox(height: 5,),
                Divider(),
                HistoryCard(date: "05 Oct 2022", sent: false, receiver: "Daniel Mwema (cd)", amount: 250),
                SizedBox(height: 20,),
                Text("2020", style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor.withOpacity(.3)
                ),),
                SizedBox(height: 5,),
                HistoryCard(date: "05 Oct 2022", sent: false, receiver: "Daniel Mwema (cd)", amount: 250),
              ],
            ),
          ),
        )
    );
  }
}