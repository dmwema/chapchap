import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/appbar_drawer.dart';
import 'package:chapchap/res/components/country_select_modal.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/payment_methods_modal.dart';
import 'package:chapchap/res/components/recipient_card.dart';
import 'package:chapchap/res/components/send_bottom_modal.dart';
import 'package:flutter/material.dart';

class SendView extends StatefulWidget {
  const SendView({Key? key}) : super(key: key);

  @override
  State<SendView> createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {

  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void insert(content, TextEditingController controller) {
    if (controller == _toController) {
      content = content.floorToDouble();
    } else {
      content = content.ceilToDouble();
    }
    controller.value = TextEditingValue(
      text: content.toString(),
      selection: TextSelection.collapsed(offset: content.toString().length),
    );
  }

  List countries = [
    {
      "code": "cd",
      "name": "République Démocratique du Congo",
      "phone": "+243",
      "device": "USD",
      "rate": 1.2
    },
    {
      "code": "ca",
      "name": "Canada",
      "phone": "+1",
      "device": "CAD",
      "rate": 1
    },
    {
      "code": "ci",
      "name": "Côte d'ivoire",
      "phone": "+225",
      "device": "USD",
      "rate": 1.4
    },
    {
      "code": "bj",
      "name": "Bénin",
      "phone": "+229",
      "device": "USD",
      "rate": 1.7
    },
  ];
  Map selectedCountry = {
    "code": "cd",
    "name": "République Démocratique du Congo",
    "phone": "+243",
    "device": "USD",
    "rate": 1.2
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          showBack: true,
          title: "Envoi d'argent",
        ),
        drawer: AppbarDrawer(),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Montant à envoyer *", style: TextStyle(
                    color: Colors.black.withOpacity(.6),
                    fontSize: 13
                ),),
                const SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(.3), width: 1.5),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset("packages/country_icons/icons/flags/png/ca.png", width: 30, height: 15, fit: BoxFit.contain),
                      const SizedBox(width: 10,),
                      const Text("CAD", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),),
                      const SizedBox(width: 10,),
                      Expanded(child: TextFormField(
                        controller: _fromController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (value != "") {
                            insert(double.parse(value) / selectedCountry["rate"], _toController);
                          } else {
                            insert("", _toController);
                          }
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "0.00",
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(
                            fontSize: 18
                        ),
                      ))
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Text("Motant à recevoir *", style: TextStyle(
                    color: Colors.black.withOpacity(.6),
                    fontSize: 13
                ),),
                const SizedBox(height: 10,),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 5, bottom: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black.withOpacity(.3), width: 1.5),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(selectedCountry["device"], style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),),
                            const SizedBox(width: 10,),
                            Expanded(child: TextFormField(
                              controller: _toController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                if (value != "") {
                                  insert(double.parse(value) * selectedCountry["rate"], _fromController);
                                } else {
                                  insert("", _fromController);
                                }
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "0.00",
                                  contentPadding: EdgeInsets.zero
                              ),
                              style: const TextStyle(
                                  fontSize: 18
                              ),
                            )),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return Container(
                                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text("Séléctionnez le pays de destination", style: TextStyle(
                                              fontWeight: FontWeight.w600
                                          ),),
                                          const SizedBox(height: 5,),
                                          const Divider(),
                                          const SizedBox(height: 5,),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedCountry = {
                                                  "code": "ci",
                                                  "name": "Côte d'ivoire",
                                                  "phone": "+225",
                                                  "device": "EUR",
                                                  "rate": 0.75
                                                };
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset("packages/country_icons/icons/flags/png/ci.png", width: 20, height: 20, fit: BoxFit.contain,),
                                                const SizedBox(width: 20,),
                                                const Text("Côte d'ivoire", style: TextStyle(
                                                    fontSize: 14
                                                ),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 5,),
                                          const Divider(),
                                          const SizedBox(height: 5,),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedCountry = {
                                                  "code": "cd",
                                                  "name": "République Démocratique du Congo",
                                                  "phone": "+243",
                                                  "device": "USD",
                                                  "rate": 0.7
                                                };
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset("packages/country_icons/icons/flags/png/cd.png", width: 20, height: 20, fit: BoxFit.contain,),
                                                const SizedBox(width: 20,),
                                                const Text("République Démocratique du Congo", style: TextStyle(
                                                    fontSize: 14
                                                ),)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 5,),
                                          const Divider(),
                                          const SizedBox(height: 5,),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedCountry =
                                                {
                                                  "code": "bj",
                                                  "name": "Bénin",
                                                  "phone": "+229",
                                                  "device": "EUR",
                                                  "rate": 0.7
                                                };
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset("packages/country_icons/icons/flags/png/bj.png", width: 20, height: 20, fit: BoxFit.contain,),
                                                const SizedBox(width: 20,),
                                                const Text("Bénin", style: TextStyle(
                                                    fontSize: 14
                                                ),)
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                  );
                                },
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                ),

                            );
                          },
                          child: Container(
                            color: Colors.black.withOpacity(.05),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Image.asset("packages/country_icons/icons/flags/png/${selectedCountry["code"]}.png", width: 15, height: 15, fit: BoxFit.contain),
                                const SizedBox(width: 10,),
                                Text(selectedCountry["name"], style: const TextStyle(
                                    fontSize: 12  ,
                                    fontWeight: FontWeight.w500
                                ),),
                                const SizedBox(width: 10,),
                                const Expanded(child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.arrow_drop_down, color: Colors.green,),
                                ))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text("(1CAD = ${selectedCountry["rate"]}${selectedCountry["device"]})", style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.black.withOpacity(.4)
                        ),),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            const Text("Mode de reception", style: TextStyle(
                                fontWeight: FontWeight.w500
                            ),),
                            const SizedBox(width: 10,),
                            InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) {
                                      return const PaymentMethodsModal();
                                    },
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),

                                  );
                                },
                              child: Row(
                                children: const [
                                  Text("Mpesa"),
                                  SizedBox(width: 5,),
                                  Icon(Icons.arrow_drop_down, color: Colors.green,)
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    )
                ),
                const SizedBox(height: 20,),
                Text("Le montant est déposé sur le portefeuille mobile de votre bénéficiaire.", style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Colors.black.withOpacity(.7)
                ),),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Bénéficiaire *", style: TextStyle(
                        color: Colors.black.withOpacity(.6),
                        fontSize: 14
                    ),),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.3),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: const Text("+ Ajouter un bénéficiaire", style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500
                        ),),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15,),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(.3), width: 1.5),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text("Choisissez un bénéficiaire", style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),),
                      SizedBox(width: 10,),
                      Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.arrow_drop_down, size: 30,),
                          )
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Nom", style: TextStyle(
                            fontSize: 13,
                            color: Colors.black.withOpacity(.5)
                        ),),
                        const Text("Daniel Mwema", style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600
                        ),),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Téléphone", style: TextStyle(
                            fontSize: 13,
                            color: Colors.black.withOpacity(.5)
                        ),),
                        const Text("+243 123 456 789", style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600
                        ),),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30,),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return const SendBottomModal();
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),

                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text("Envoyer", style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16, color: Colors.white
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