import 'dart:io';

import 'package:mardona/common/common_widgets.dart';
import 'package:mardona/data/response/status.dart';
import 'package:mardona/model/pays_model.dart';
import 'package:mardona/model/user_model.dart';
import 'package:mardona/res/app_colors.dart';
import 'package:mardona/res/app_texts.dart';
import 'package:mardona/res/components/auth_container.dart';
import 'package:mardona/res/components/custom_appbar.dart';
import 'package:mardona/res/components/custom_field.dart';
import 'package:mardona/res/components/rounded_button.dart';
import 'package:mardona/utils/routes/routes_name.dart';
import 'package:mardona/utils/utils.dart';
import 'package:mardona/view_model/auth_view_model.dart';
import 'package:mardona/view_model/demandes_view_model.dart';
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
      backgroundColor: AppColors.bgColor,
      appBar: CommonAppBar(context: context, backArrow: true, backClick: () {
        Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (route) => false);
      },),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                            AppTexts.titleText("Veuillez fournir votre numéro de téléphone"),
                            const SizedBox(height: 10,),
                            AppTexts.descriptionText("Vous devez fournir votre numéro de téléphone pour continuer"),
                            const SizedBox(height: 20,),
                            AppTexts.smallText("Numéro de téléphone"),
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
                                            AppTexts.titleText("Séléctionnez votre pays"),
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
                                                      child: Row(
                                                        children: [
                                                          Image.asset("packages/country_icons/icons/flags/png/${current.codePays}.png", width: 20, height: 20, fit: BoxFit.contain,),
                                                          const SizedBox(width: 20,),
                                                          AppTexts.smallText("${current.paysNom} (${current.paysIndictel})")
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
                                          AppTexts.smallText(selectedPays!.paysIndictel.toString()),
                                        ],
                                      ),
                                    ),
                                    CustomFormField(
                                      label: "Téléphone *", hint: "Téléphone *",
                                      controller: _phoneNumberController,
                                      type: TextInputType.phone,
                                    )
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
                                        'telephone': selectedPays!.paysIndictel.toString() + _phoneNumberController.text.toString(),
                                        'username': widget.data['email'],
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