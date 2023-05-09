
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: user != null ? CustomAppBar(
          title: "Mes coupons rabais",
          showBack: true,
          backUrl: RoutesName.home,
        ): null,
        body: ChangeNotifierProvider<DemandesViewModel>(
            create: (BuildContext context) => demandesViewModel,
            child: Consumer<DemandesViewModel>(
                builder: (context, value, _){
                  switch (value.promoList.status) {
                    case Status.LOADING:
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 200,
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors.primaryColor,),
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
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: ListView.builder(
                            itemCount: value.promoList.data!.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Container(
                                  padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                                          decoration: BoxDecoration(
                                              color: Colors.orange.withOpacity(.1),
                                              borderRadius: BorderRadius.circular(8.0),
                                              border: Border.all(color: Colors.orange)
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Rabais de 10\$ !',
                                                style: TextStyle(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              const Text(
                                                "Lorsqu'une personne fait son premier transfert avec votre code de parrainage",
                                                style: TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              const Divider(),
                                              const Text(
                                                'Code promo',
                                                style: TextStyle(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              const SizedBox(height: 5,),
                                              if (user != null)
                                              Text(
                                                user!.codeParrainage.toString(),
                                                style: TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                              const Divider(),
                                              const Text(
                                                'Url parrainage',
                                                style: TextStyle(
                                                  color: Colors.orange,
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
                                          )
                                      ),
                                      const SizedBox(height: 10,),
                                    ],
                                  ),
                                );
                              }
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
                                    Text("Type : " + value.promoList.data![index-1]["typeCodePromo"]),
                                    const SizedBox(height: 5,),
                                    Text("Code : " + value.promoList.data![index-1]["codePromo"]),
                                    const SizedBox(height: 5,),
                                    Text("Montant : ${value.promoList.data![index-1]["montantCodePromo"]}"),
                                  ],
                                ),
                              );
                            },
                          )),
                        ],
                      );
                  }
                })
        )
      /*Container(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.orange)
                  ),
                  child: Flexible(
                    child: Flexible(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rabais de 10\$ !',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          "Lorsqu'une personne fait son premier transfert avec votre code de parrainage",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 14.0,
                          ),
                        ),
                        const Divider(),
                        if (user != null)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Code promo',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Text(
                                user!.codeParrainage.toString(),
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        const Divider(),
                        if (user != null)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Url parrainage',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Text(
                                'https://chapchap.ca/signup-${user!.codeParrainage}.html',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          )
                      ],
                    ),)
                  )
              ),
              const SizedBox(height: 10,),
            ],
          ),
        )*/
    );
  }
}