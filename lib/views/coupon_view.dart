
import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CouponView extends StatefulWidget {
  const CouponView({Key? key}) : super(key: key);


  @override
  State<CouponView> createState() => _CouponViewState();
}

class _CouponViewState extends State<CouponView> {
  UserModel? user;
  DemandesViewModel demandesViewModel = DemandesViewModel();

  @override
  void initState() {
    demandesViewModel.myPromos(context);
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  bool loadEmail = false;
  bool loadSMS = false;

  Future<void> _openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      setState(() {
        loadEmail = false;
        loadSMS = false;
      });
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.formFieldColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonAppBar(
              context: context,
              backArrow: true
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mes coupons rabais", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 5),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(CupertinoIcons.gift_fill, color: AppColors.primaryColor, size: 40,),
                      const SizedBox(height: 10),
                      const Text(
                        'Rabais de 10\$ !',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      const SizedBox(
                        width: 230,
                        child: Text(
                          "Lorsqu'une personne fait son premier transfert avec votre code de parrainage",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Code de parrainage',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                          const SizedBox(width: 5,),
                          if (user != null)
                            Text(
                              user!.codeParrainage.toString(),
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                              ),
                            ),
                          const SizedBox(width: 10,),
                          if (user != null)
                            InkWell(
                              onTap: () {
                                final box = context.findRenderObject() as RenderBox?;
                                Share.share(
                                  "Découvrez Transfert ChapChap! 🎉🎉🎉 \n\nUne application facile à utiliser pour envoyer de l'argent à ses proche dans plusieurs pays du monde.\nObtenez-le à cette adresse https://chapchap.ca\n\nUtilisez le code ${user!.codeParrainage} pour gagner 10\$ et me faire gagner 10\$",
                                  sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                                );
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: const Center(child: Icon(Icons.share_outlined, size: 13, color: Colors.white,)),
                              ),
                            )
                        ],
                      ),
                      const Divider(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Url parrainage',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.0,
                            ),
                          ),
                          const SizedBox(height: 5,),
                          if (user != null)
                            Text(
                              'https://chapchap.ca/signup-${user!.codeParrainage}.html',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            if (user != null && user!.soldeParrainage != null)
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 5),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Gains",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                      if (user != null)
                      Text(
                        "${user!.soldeParrainage} ${user!.paysMonnaie ?? ''}",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      if (user != null)
                      SizedBox(
                        width: 230,
                        child: Text(
                          "Vous avez ${user!.soldeParrainage} ${user!.paysMonnaie ?? ''} comme solde de parrainage.",
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                ],
              ),
            ),
            Expanded(
              child: ChangeNotifierProvider<DemandesViewModel>(
                  create: (BuildContext context) => demandesViewModel,
                  child: Consumer<DemandesViewModel>(
                      builder: (context, value, _){
                        switch (value.promoList.status) {
                          case Status.LOADING:
                            return SizedBox(
                              height: MediaQuery.of(context).size.height - 200,
                              child: const Center(
                                child: CupertinoActivityIndicator(color: Colors.black,),
                              ),
                            );
                          case Status.ERROR:
                            return Center(
                              child: Text(value.promoList.message.toString()),
                            );
                          default:
                            if (value.promoList.data!.length == 0) {
                              return Center(
                                child: Text(
                                  "Vous n'avez aucun code Promo",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(.2),
                                  ),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: value.promoList.data!.length + 1,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1, color: Colors.black),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text("Type : " + value.promoList.data![index]["typeCodePromo"]),
                                            const SizedBox(height: 5,),
                                            Text("Code : " + value.promoList.data![index]["codePromo"]),
                                            const SizedBox(height: 5,),
                                            Text("Montant : ${value.promoList.data![index]["montantCodePromo"]}"),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                        }
                      })
              ),
            ),
          ],
        ),
      )
    );
  }
}