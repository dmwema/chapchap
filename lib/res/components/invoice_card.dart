import 'dart:io';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/cupertino.dart';
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
    return commonRoundedContainer(
      removePaddingH: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20.0, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTexts.smallText(demande.datePaidBen.toString()),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    Image.asset("packages/country_icons/icons/flags/png/${demande.codePaysSrce}.png", width: 30,),
                    const SizedBox(width: 10,),
                    const Icon(Icons.arrow_forward, size: 20,),
                    const SizedBox(width: 10,),
                    Image.asset("packages/country_icons/icons/flags/png/${demande.codePaysDest}.png", width: 30,),
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
                                  width: 12,
                                  height: 12,
                                  child: CupertinoActivityIndicator(
                                    color: Colors.white,
                                  )
                              ),
                            SizedBox(width: loading ? 10 : 7,),
                            AppTexts.smallButtonText("Télécharger", color: Colors.white)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          commonDivider(),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20.0, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTexts.smallText("Bénéficiaire"),
                    AppTexts.bodyText(demande.beneficiaire.toString(), bold: true),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTexts.smallText("Montant"),
                    AppTexts.bodyText("${demande.montanceSrce} ${demande.paysCodeMonnaieDest}", bold: true),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}