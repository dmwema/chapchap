import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/appbar_drawer.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class ExchangeView extends StatefulWidget {
  const ExchangeView({Key? key}) : super(key: key);

  @override
  State<ExchangeView> createState() => _ExchangeViewState();
}

class _ExchangeViewState extends State<ExchangeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          showBack: true,
          title: 'Taux de change',
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
                Row(
                  children: [
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 60) * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("De", style: TextStyle(
                              color: Colors.black.withOpacity(.6),
                              fontSize: 13
                          ),),
                          const SizedBox(height: 5,),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black.withOpacity(.3), width: 1.5),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset("packages/country_icons/icons/flags/png/ca.png", width: 20, height: 15, fit: BoxFit.contain),
                                const SizedBox(width: 10,),
                                const Text("CAD", style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),),
                                const SizedBox(width: 10,),
                                Expanded(child: Align(
                                  alignment: Alignment.centerRight,
                                  child: const Icon(Icons.arrow_drop_down),
                                ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20,),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 60) * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("À", style: TextStyle(
                              color: Colors.black.withOpacity(.6),
                              fontSize: 13
                          ),),
                          const SizedBox(height: 5,),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black.withOpacity(.3), width: 1.5),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset("packages/country_icons/icons/flags/png/cd.png", width: 20, height: 15, fit: BoxFit.contain),
                                const SizedBox(width: 10,),
                                const Text("USD", style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),),
                                const SizedBox(width: 10,),
                                const Expanded(child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.arrow_drop_down),
                                ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Montant", style: TextStyle(
                        color: Colors.black.withOpacity(.6),
                        fontSize: 13
                    ),),
                    const SizedBox(height: 5,),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        fillColor: Colors.white,
                        focusColor: AppColors.primaryColor,
                        hintText: "0.00",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black.withOpacity(.4),
                            width: 1.0,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                          fontSize: 18
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30,),
                Container(
                  padding: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1),
                    color: Colors.black.withOpacity(.1),
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1 250 CAD =", style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.black.withOpacity(.7)
                        ),),
                        const SizedBox(height: 5,),
                        Text("1025 USD", style: TextStyle(
                          fontSize: 40,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),),
                        SizedBox(height: 10,),
                        Divider()
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text("Convertir", style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                      ),),
                    )
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}