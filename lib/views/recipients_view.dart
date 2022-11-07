import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/appbar_drawer.dart';
import 'package:chapchap/res/components/country_select_modal.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/history_card.dart';
import 'package:chapchap/res/components/payment_methods_modal.dart';
import 'package:chapchap/res/components/recipient_card.dart';
import 'package:chapchap/res/components/recipient_card2.dart';
import 'package:chapchap/res/components/send_bottom_modal.dart';
import 'package:flutter/material.dart';

class RecipientsView extends StatefulWidget {
  const RecipientsView({Key? key}) : super(key: key);

  @override
  State<RecipientsView> createState() => _RecipientsViewState();
}

class _RecipientsViewState extends State<RecipientsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          showBack: true,
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
                const Text("Bénéficiaires", style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black
                ),),
                const SizedBox(height: 20,),
                Text("Vous pouvez glisser de droite à gauche pour supprimer", style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: AppColors.primaryColor
                ),),
                const SizedBox(height: 20,),
                const RecipientCard2(
                  name: "Daniel Mwema (cd)",
                  address: "21, loango Q1 Ndjili",
                  phone: "+243 234 567 789",
                ),
                const SizedBox(
                  height: 20,
                ),
                const RecipientCard2(
                  name: "Jhon Doe (ca)",
                  phone: "+1 (123) 456 789",
                  address: "2955 Maricourt, Quebec",
                ),
              ],
            ),
          ),
        )
    );
  }
}