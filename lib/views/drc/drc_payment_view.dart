import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/material.dart';

class DRCPaymentView extends StatefulWidget {
  const DRCPaymentView({Key? key}) : super(key: key);

  @override
  State<DRCPaymentView> createState() => _DRCPaymentViewSatet();
}

class _DRCPaymentViewSatet extends State<DRCPaymentView> {
  DemandesViewModel demandesViewModel = DemandesViewModel();

  @override
  void initState() {
    super.initState();
    demandesViewModel.beneficiairesArchive([], context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonAppBar(
                context: context,
                backArrow: true,
                backClick: () {
                  Navigator.pushNamed(context, RoutesName.recipeints);
                }
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("Paiement", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Veuillez choisir la methode de paiement de votre choix", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black54), textAlign: TextAlign.left,),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
              ),
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                children: [
                  Image.asset("assets/equity.png", width: 50,),
                  const SizedBox(width: 10,),
                  const Text("Equity BCDC", style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),)
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
              ),
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                children: [
                  Image.asset("assets/mpesa.png", width: 40,),
                  const SizedBox(width: 10,),
                  const Text("Vodacom M-PESA", style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),)
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
              ),
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                children: [
                  Image.asset("assets/orange.png", width: 40,),
                  const SizedBox(width: 10,),
                  const Text("Orange Money", style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),)
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
              ),
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                children: [
                  Image.asset("assets/airtel.png", width: 50,),
                  const SizedBox(width: 10,),
                  const Text("Airtel Money", style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}