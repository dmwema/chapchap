import 'dart:io';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/pays_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/auth_container.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/services/local_auth_service.dart';
import 'package:chapchap/view_model/services/notifications_service.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdatePhoneView extends StatefulWidget {
  Map data;
  UpdatePhoneView({required this.data, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UpdatePhoneViewState();
}

class _UpdatePhoneViewState extends State<UpdatePhoneView> {
  final TextEditingController _phoneNumberController = TextEditingController();

  UserModel? user;
  List paysList = [];
  PaysModel? selectedPays;
  bool loading = false;

  DemandesViewModel demandesViewModel = DemandesViewModel();
  AuthViewModel authViewModel = AuthViewModel();

  @override
  void initState() {
    super.initState();
    demandesViewModel.paysActifs([], context);
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonAppBar(
              context: context,
              backArrow: true,
              backClick: () {
                Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (route) => false);
              }
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: ChangeNotifierProvider<DemandesViewModel>(
                create: (BuildContext context) => demandesViewModel,
                child: Consumer<DemandesViewModel>(
                  builder: (context, value, _) {
                    switch (value.paysActifList.status) {
                      case Status.LOADING:
                        return const Center(
                          child: Column(
                            children: [
                              SizedBox(height: 20,),
                              CupertinoActivityIndicator(color: Colors.black,),
                            ],
                          ),
                        );
                      case Status.ERROR:
                        return Center(
                          child: Text(value.paysActifList.message.toString()),
                        );
                      default:
                        paysList = value.paysActifList.data!;
                        selectedPays ??= PaysModel.fromJson(paysList[0]);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20,),
                            const Text("Veuillez fournir votre numéro de téléphone", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
                            const SizedBox(height: 10,),
                            const Text("Vous devez fournir votre numéro de téléphone pour continuer", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black45), textAlign: TextAlign.left,),
                            const SizedBox(height: 20,),
                            const Text("Numéro de téléphone", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black), textAlign: TextAlign.left,),
                            const SizedBox(height: 10,),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text("Séléctionnez votre pays", style: TextStyle(
                                                fontWeight: FontWeight.w600
                                            ),),
                                            const SizedBox(height: 20,),
                                            Expanded(child: ListView.builder(
                                              itemCount: paysList.length,
                                              itemBuilder: (context, index) {
                                                PaysModel current = PaysModel.fromJson(paysList[index]);
                                                return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedPays = current;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(width: 1, color: Colors.black.withOpacity(.1))
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Image.asset("packages/country_icons/icons/flags/png/${current.codePays}.png", width: 20, height: 20, fit: BoxFit.contain,),
                                                          const SizedBox(width: 20,),
                                                          Text("${current.paysNom} (${current.paysIndictel})", style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold
                                                          ),)
                                                        ],
                                                      ),
                                                    )
                                                );
                                              },
                                            ))
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
                                decoration: BoxDecoration(
                                    color: AppColors.formFieldColor,
                                    border: Border.all(width: 1, color: AppColors.formFieldBorderColor),
                                    borderRadius: BorderRadius.circular(6)
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 10),
                                      decoration: BoxDecoration(
                                          color: AppColors.formFieldBorderColor,
                                          // border: Border.all(width: 1, color: AppColors.formFieldBorderColor),
                                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(6), topLeft: Radius.circular(6))
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset("packages/country_icons/icons/flags/png/${selectedPays!.codePays}.png", width: 20,),
                                          const SizedBox(width: 5,),
                                          const Icon(Icons.arrow_drop_down)
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 10, bottom: 3),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(selectedPays!.paysIndictel.toString(), style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16
                                          ),),
                                        ],
                                      ),
                                    ),
                                    Flexible(child: TextFormField(
                                      controller: _phoneNumberController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: AppColors.formFieldColor,
                                        hintText: "Téléphone *",
                                        hintStyle: TextStyle(
                                            color: Colors.black.withOpacity(.25)
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.formFieldColor),// Changer la couleur de la bordure
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.formFieldColor),
                                        ),
                                        contentPadding: const EdgeInsets.only(left: 6),
                                      ),
                                      onTap: () {

                                      },
                                    ))
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            RoundedButton(
                                title: "Valider",
                                loading: loading,
                                onPress: () async {
                                  if (!loading) {
                                    setState(() {
                                      loading = true;
                                    });
                                    if (_phoneNumberController.text.isEmpty) {
                                      Utils.flushBarErrorMessage("Vous devez entrer le numéro de téléphone", context);
                                    } else {
                                      Map data = {
                                        'telephone': _phoneNumberController.text.toString(),
                                        'username': widget.data['email']
                                      };
                                      await authViewModel.updatePhone(data, context, widget.data['token']);
                                      setState(() {
                                        loading = false;
                                      });
                                    }
                                  }
                                }
                            )
                          ],
                        );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}