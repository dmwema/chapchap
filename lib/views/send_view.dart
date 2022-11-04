import 'package:chapchap/res/components/appbar_drawer.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
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
        ),
        drawer: AppbarDrawer(),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Envoi d'argent", style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black
              ),),
              const SizedBox(height: 30,),
              Text("Montant à envoyer *", style: TextStyle(
                color: Colors.black.withOpacity(.6),
                fontSize: 14
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
                    const Text("CAD", style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),),
                    const SizedBox(width: 10,),
                    Expanded(child: TextFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "0.00",
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        fontSize: 20
                      ),
                    ))
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Text("Motant à recevoir *", style: TextStyle(
                  color: Colors.black.withOpacity(.6),
                  fontSize: 14
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
                          fontSize: 20,
                        ),),
                        const SizedBox(width: 10,),
                        Expanded(child: TextFormField(
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "0.00",
                              contentPadding: EdgeInsets.zero
                          ),
                          style: const TextStyle(
                              fontSize: 20
                          ),
                        )),
                      ],
                    ),
                    InkWell(
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
              const Text("Le montant est déposé sur le portefeuille mobile de votre bénéficiaire.")
            ],
          ),
        )
    );
  }
}