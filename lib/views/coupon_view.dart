
import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/data/response/status.dart';
import 'package:mardona/model/user_model.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/utils/routes/routes_name.dart';
import 'package:mardona/utils/utils.dart';
import 'package:mardona/view_model/demandes_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mardona/res/components/custom_appbar.dart';
import 'package:mardona/view_model/user_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: AppColors.bgColor,
      appBar: CommonAppBar(context: context, backArrow: true,),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: AppTexts.titleText("Mes coupons rabais"),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: commonRoundedContainer(
                removePaddingH: true,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                              AppTexts.bodyText(
                                'Rabais de 10\$ !', bold: true
                              ),
                              const SizedBox(height: 5.0),
                              SizedBox(
                                width: 230,
                                child: AppTexts.smallText(
                                  "Lorsqu'une personne fait son premier transfert avec votre code de parrainage"
                                ),
                              ),
                              Divider(color: AppColors.bgColor,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppTexts.smallText(
                                    'Code de parrainage'
                                  ),
                                  const SizedBox(width: 5,),
                                  if (user != null)
                                    SelectableText(user!.codeParrainage.toString(), style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    ),),
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
                              Divider(color: AppColors.bgColor,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppTexts.cardDescription(
                                    'Url parrainage',
                                  ),
                                  const SizedBox(height: 5,),
                                  if (user != null)
                                    SelectableText('https://chapchap.ca/signup-${user!.codeParrainage}.html', style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12
                                    ),),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15,),
                    commonDivider(),
                    const SizedBox(height: 15,),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AppTexts.bodyText(
                                "Gains", bold: true
                              ),
                              if (user != null)
                                AppTexts.titleText(
                                  "${user!.soldeParrainage} ${user!.paysMonnaie ?? ''}", color: AppColors.primaryColor
                                ),
                              const SizedBox(height: 5.0),
                              if (user != null)
                                SizedBox(
                                  width: 230,
                                  child: AppTexts.cardDescription(
                                    "Vous avez ${user!.soldeParrainage} ${user!.paysMonnaie ?? ''} comme solde de parrainage.",
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
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
                                child: AppTexts.descriptionText(
                                  "Vous n'avez aucun code Promo",
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
                                            AppTexts.smallText("Type : ${value.promoList.data![index]["typeCodePromo"]}"),
                                            const SizedBox(height: 5,),
                                            AppTexts.smallText("Code : ${value.promoList.data![index]["codePromo"]}"),
                                            const SizedBox(height: 5,),
                                            AppTexts.smallText("Montant : ${value.promoList.data![index]["montantCodePromo"]}"),
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