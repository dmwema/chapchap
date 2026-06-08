import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class DRCPaymentView extends StatefulWidget {
  Map data;
  DRCPaymentView({required Map this.data,  Key? key}) : super(key: key);

  @override
  State<DRCPaymentView> createState() => _DRCPaymentViewSatet();
}

class _DRCPaymentViewSatet extends State<DRCPaymentView> {
  DemandesViewModel demandesViewModel = DemandesViewModel();

  List paymentMethods = [
    {
      'number': '733100101500454',
      'name': 'Equity BCDC',
      'key': 'equity'
    },
    {
      'number': '0821690038',
      'name': 'Vodacom M-pesa',
      'key': 'mpesa'
    },
    {
      'number': '0852498766',
      'name': 'Orange Money',
      'key': 'orange'
    },
  ];

  int? selectedPaymentMethod;

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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(AppLocalizations.of(context).paymentTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.04)
                      ),
                      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context).beneficiary,
                                style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black54, fontSize: 12),
                              ),
                              Text(widget.data['nomBeneficiaire'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppLocalizations.of(context).amount,
                                style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black54, fontSize: 12),
                              ),
                              Text(widget.data['montant'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(AppLocalizations.of(context).paymentMethodQuestion,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.black87),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: paymentMethods.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedPaymentMethod = index;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: selectedPaymentMethod != null && selectedPaymentMethod == index
                                        ? 2 : 1, color: selectedPaymentMethod != null && selectedPaymentMethod == index
                                    ? AppColors.primaryColor : Colors.grey.withOpacity(.5)),
                              ),
                              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              child: Row(
                                children: [
                                  Image.asset("assets/${paymentMethods[index]['key']}.png", height: 20),
                                  const SizedBox(width: 10),
                                  Text(paymentMethods[index]['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          );
                        }
                    ),
                    if (selectedPaymentMethod != null)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: AppColors.primaryColor),
                        ),
                        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset("assets/${paymentMethods[selectedPaymentMethod!]['key']}.png", height: 40),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text("${AppLocalizations.of(context).payWith} ${paymentMethods[selectedPaymentMethod!]['name']}",
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Divider(),
                            const SizedBox(height: 10),
                            SelectableText.rich(
                                TextSpan(
                                    style: const TextStyle(fontSize: 15, height: 1.5),
                                    children: [
                                      TextSpan(
                                          text: "${AppLocalizations.of(context).payWith} ${paymentMethods[selectedPaymentMethod!]['name']}, ",
                                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)
                                      ),
                                      TextSpan(
                                          text: "${AppLocalizations.of(context).depositOrTransfer} ${paymentMethods[selectedPaymentMethod!]['name']} ${widget.data['montant'] ?? ""} ",
                                          style: const TextStyle(color: Colors.black, fontSize: 12)
                                      ),
                                      TextSpan(
                                          text: "${AppLocalizations.of(context).toNumber} ${paymentMethods[selectedPaymentMethod!]['number']} ",
                                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)
                                      ),
                                      TextSpan(
                                          text: "${AppLocalizations.of(context).thenSendProof}",
                                          style: const TextStyle(color: Colors.black, fontSize: 12)
                                      ),
                                    ]
                                )
                            ),
                            const SizedBox(height: 20),
                            RoundedButton(
                                title: AppLocalizations.of(context).sendPaymentProof,
                                onPress: () async {
                                  String s = "\n-----------------------\n";
                                  String start = "\nNous vous envoyons la preuve de paiement de la transaction suivante :\n\n";
                                  String b = widget.data['nomBeneficiaire'] ?? "";
                                  String id = widget.data['idDemande'] != null ? widget.data['idDemande'].toString() : "";
                                  String m = widget.data['montant'] ?? "";
                                  String message = "Salut,$start ID Trans : *$id* $s Montant : *$m* $s Beneficiaire : *$b* $s Canal : *${paymentMethods[selectedPaymentMethod!]['name']}*";
                                  String phoneNumber = "+243814063056";
                                  var url = "whatsapp://send?phone=$phoneNumber&text=$message";
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url));
                                  }
                                }
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
