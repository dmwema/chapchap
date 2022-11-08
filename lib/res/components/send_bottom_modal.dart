import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class SendBottomModal extends StatelessWidget {
  const SendBottomModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(topLeft: const Radius.circular(20), topRight: const Radius.circular(20))
          ),
          width: double.infinity,
          child: const Center(
            child: Text("DETAILS DE L'ENVOI", style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white
            ),),
          )
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Montant", style: TextStyle(
                    color: Colors.black.withOpacity(.5)
                  ),),
                  const Text("250.00 CAD", style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                  ),)
                ],
              ),
              SizedBox(height: 5,),
              Divider(),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Frais d'envoi", style: TextStyle(
                      color: Colors.black.withOpacity(.5)
                  ),),
                  const Text("0.00 CAD", style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                  ),)
                ],
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(15),
                color: Colors.blueGrey.withOpacity(.2),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Montant à payer", style: TextStyle(
                        color: Colors.black.withOpacity(.8),
                      fontWeight: FontWeight.w500
                    ),),
                    const Text("250.00CAD", style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    ),)
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Row(
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 40) * 0.7,
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        label: const Text("CODE PROMO", style: TextStyle(
                          fontSize: 12
                        ),),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        focusColor: AppColors.primaryColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
                          borderSide: BorderSide(
                            color: Colors.black.withOpacity(.4),
                            width: 1.0,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                          fontSize: 18
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 40) * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                        color: AppColors.primaryColor,
                      ),
                      padding: const EdgeInsets.only(top: 16, bottom: 16.6),
                      child: const Center(
                        child: Text("Appliquer", style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                        ),),
                      )
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Source", style: TextStyle(
                      color: Colors.black.withOpacity(.5)
                  ),),
                  const Text("Canada", style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                  ),)
                ],
              ),
              SizedBox(height: 10,),
              Divider(),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Destination", style: TextStyle(
                      color: Colors.black.withOpacity(.5)
                  ),),
                  const Text("Congo", style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                  ),)
                ],
              ),
              SizedBox(height: 10,),
              Divider(),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Bénéficiaire", style: TextStyle(
                      color: Colors.black.withOpacity(.5)
                  ),),
                  const Text("Daniel Mwema", style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                  ),)
                ],
              ),
              SizedBox(height: 10,),
              Divider(),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Téléphone", style: TextStyle(
                      color: Colors.black.withOpacity(.5)
                  ),),
                  const Text("+243 123 456 789", style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                  ),)
                ],
              ),
              SizedBox(height: 10,),
              Divider(),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Montant bénéficiaire", style: TextStyle(
                      color: Colors.black.withOpacity(.5)
                  ),),
                  const Text("300 USD", style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                  ),)
                ],
              ),
              SizedBox(height: 10,),
              Divider(),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Mode de retrait", style: TextStyle(
                      color: Colors.black.withOpacity(.5)
                  ),),
                  const Text("M-Pesa", style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                  ),)
                ],
              ),
              const SizedBox(height: 15,),

              Row(
                children: [
                  InkWell(
                    child: Container(
                        width: (MediaQuery.of(context).size.width - 40) * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                          color: AppColors.primaryColor,
                        ),
                        padding: const EdgeInsets.only(top: 16, bottom: 16.6),
                        child: const Center(
                          child: Text("Annueler", style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                          ),),
                        )
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.sendSuccess);
                    },
                    child: Container(
                        width: (MediaQuery.of(context).size.width - 40) * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                          color: Colors.black.withOpacity(.9),
                        ),
                        padding: const EdgeInsets.only(top: 16, bottom: 16.6),
                        child: const Center(
                          child: Text("Confirmer", style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white
                          ),),
                        )
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}