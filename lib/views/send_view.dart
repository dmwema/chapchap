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
                            const Text("USD", style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),),
                            const SizedBox(width: 10,),
                            Expanded(child: TextFormField(
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
                                  return const CountrySelectModal();
                                },
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                ),

                            );
                          },
                          child: Row(
                            children: [
                              Image.asset("packages/country_icons/icons/flags/png/cd.png", width: 15, height: 15, fit: BoxFit.contain),
                              const SizedBox(width: 10,),
                              const Text("République Démocratique du Congo", style: TextStyle(
                                  fontSize: 12  ,
                                  fontWeight: FontWeight.w500
                              ),),
                              const SizedBox(width: 10,),
                              const Icon(Icons.arrow_drop_down, color: Colors.green,),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Text("(1CAD = 0.9USD)", style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.black.withOpacity(.4)
                        ),),
                        const SizedBox(height: 15,),
                        Row(
                          children: [
                            const Text("Mode de reception", style: TextStyle(
                                fontWeight: FontWeight.w500
                            ),),
                            const SizedBox(width: 15,),
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
                const SizedBox(height: 10,),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      RecipientCard(),
                      RecipientCard(
                        active: true,
                      ),
                      RecipientCard(),
                      RecipientCard(),
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
                            fontSize: 14,
                            color: Colors.black.withOpacity(.5)
                        ),),
                        const Text("Daniel Mwema", style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600
                        ),),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Téléphone", style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(.5)
                        ),),
                        const Text("+243 123 456 789", style: TextStyle(
                            fontSize: 15,
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