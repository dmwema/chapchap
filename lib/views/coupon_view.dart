
import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
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
            const SizedBox(height: 10,),
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
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 5),
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
                      Icon(CupertinoIcons.gift_fill, color: AppColors.primaryColor, size: 60,),
                      const SizedBox(height: 10),
                      const Text(
                        'Rabais de 10\$ !',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      const SizedBox(
                        width: 230,
                        child: Flexible(
                          child: Text(
                            "Lorsqu'une personne fait son premier transfert avec votre code de parrainage",
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    builder: (context) {
                                      return Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text("Partager votre code de parrainage", style: TextStyle(
                                                fontWeight: FontWeight.bold
                                            ),),
                                            const SizedBox(height: 15,),
                                            InkWell(
                                              onTap: () {
                                                if (user != null && !loadEmail && !loadSMS) {
                                                  setState(() {
                                                    loadEmail = true;
                                                  });
                                                  _openUrl("mailto:?subject=Partage%20du%20code%20de%20parrainage%20ChapChap&body=Voici%20mon%20code%20de%20parrainage%20ChapChap%20%3A%20${user!.codeParrainage}%0AUtilise%20le%20pour%20t%E2%80%99inscrire%20sur%20transfert%20ChapChap%20et%20b%C3%A9n%C3%A9ficie%20de%2010%24%20gratuit");
                                                }
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                                decoration: BoxDecoration(
                                                    color: AppColors.primaryColor,
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: Row(
                                                  children: [
                                                    if (loadEmail)
                                                      const SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                                      ),
                                                    const SizedBox(width: 10,),
                                                    const Text("Partager par mail", style: TextStyle(
                                                        color: Colors.white
                                                    ),)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10,),
                                            InkWell(
                                              onTap: () {
                                                if (user != null && !loadEmail && !loadSMS) {
                                                  setState(() {
                                                    loadSMS = true;
                                                  });
                                                  _openUrl("sms:&body=Voici%20mon%20code%20de%20parrainage%20ChapChap%20%3A%20${user!.codeParrainage}%0AUtilise%20le%20pour%20t%E2%80%99inscrire%20sur%20transfert%20ChapChap%20et%20b%C3%A9n%C3%A9ficie%20de%2010%24%20gratuit");
                                                }
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: Row(
                                                  children: [
                                                    if (loadSMS)
                                                      const SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                                      ),
                                                    const SizedBox(width: 10,),
                                                    const Text("Partager par SMS", style: TextStyle(
                                                        color: Colors.white
                                                    ),)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
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
                              fontSize: 12.0,
                            ),
                          ),
                          const SizedBox(height: 5,),
                          if (user != null)
                            Text(
                              'https://chapchap.ca/signup-${user!.codeParrainage}.html',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                              ),
                            ),
                        ],
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
                                  Expanded(child: ListView.builder(
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
                                  )),
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