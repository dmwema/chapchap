import 'dart:io';

import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

class InvoiceCard extends StatefulWidget {
  final DemandeModel demande;
  InvoiceCard({Key? key, required this.demande}) : super(key: key);

  @override
  State<InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard> {
  bool loading = false;
  var _openResult = 'Unknown';

  Future<void> openFile(String filePath) async {
    final result = await OpenFilex.open(filePath);

    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    DemandeModel demande = widget.demande;
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black.withOpacity(.4), width: 1)
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(demande.datePaidBen.toString(), style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withOpacity(.6)
                ),),
              ],
            ),
            const SizedBox(height: 5,),
            Row(
              children: [
                Image.asset("packages/country_icons/icons/flags/png/${demande.codePaysSrce}.png", width: 20,),
                const SizedBox(width: 10,),
                const Icon(Icons.arrow_forward, size: 20,),
                const SizedBox(width: 10,),
                Image.asset("packages/country_icons/icons/flags/png/${demande.codePaysDest}.png", width: 20,),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    if (!loading) {
                      setState(() {
                        loading = true;
                      });
                      DemandesViewModel demandeVM = DemandesViewModel();
                      File file = await demandeVM.getFileContent(demande.facture.toString(), context: context);
                      print(file.path);
                      try {
                        openFile(file.path);
                      } catch (error) {
                        Utils.flushBarErrorMessage("Une erreur est survenue, veuillez ressayer.", context);
                      }

                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Row(
                      children: [
                        if (!loading)
                        const Icon(Icons.download, size: 20, color: Colors.white,),
                        if (loading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )
                        ),
                        SizedBox(width: loading ? 10 : 7,),
                        const Text("Télécharger", style: TextStyle(
                          color: Colors.white
                        ),)
                      ],
                    ),
                  ),
                )
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Bénéficiaire", style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(.4),
                ),),
                Text(demande.beneficiaire.toString(), style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),)
              ],
            ),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Montant", style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(.4),
                ),),
                Text("${demande.montanceSrce} ${demande.paysMonnaieSrce}", style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),)
              ],
            )
          ],
        ),
      ),
    );
  }
}