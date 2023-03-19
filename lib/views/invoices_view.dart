import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/appbar_drawer.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/invoice_card.dart';
import 'package:flutter/material.dart';

class InvoicesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Factures",
        showBack: true,
      ),
      drawer: const AppbarDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Text("Cette année", style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor.withOpacity(.3)
                ),),
                const SizedBox(height: 10,),
                InvoiceCard(),*/
                Expanded(child: Center(
                  child: Text(
                    "Aucune facture trouvée",
                    style: TextStyle(
                      color: Colors.black.withOpacity(.5)
                    ),
                  ),
                ))
              ],
            ),
          ),
        )
    );
  }
}