import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/pays_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/custom_field.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/utils/utils.dart';
import 'package:chapchap/view_model/auth_view_model.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  PaysModel? selectedPays;
  List paysList = [];
  DemandesViewModel demandesViewModel = DemandesViewModel();
  AuthViewModel authViewModel = AuthViewModel();

  @override
  void initState() {
    super.initState();
    demandesViewModel.paysActifs([], context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "CHAPCHAP",
        showBack: true,
        red: true,
      ),
      body: SingleChildScrollView(
        child: ChangeNotifierProvider<DemandesViewModel>(
          create: (BuildContext context) => demandesViewModel,
          child: Consumer<DemandesViewModel>(
            builder: (context, value, _){
              switch (value.paysActifList.status) {
                case Status.LOADING:
                  return SizedBox(
                    height: MediaQuery.of(context).size.height - 100,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primaryColor,),
                    ),
                  );
                case Status.ERROR:
                  return Center(
                    child: Text(value.paysActifList.message.toString()),
                  );
                default:
                  paysList = value.paysActifList.data!;
                  selectedPays ??= PaysModel.fromJson(paysList[0]);
                  return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text("S’inscrire", style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold
                            ),),
                            const SizedBox(height: 20,),
                            CustomFormField(
                              label: "Nom *",
                              controller: _nomController,
                              hint: "Entrez votre nom",
                              password: false,
                            ),
                            const SizedBox(height: 20,),
                            CustomFormField(
                              label: "Prénom(s) *",
                              controller: _prenomController,
                              hint: "Entrez votre prénom",
                              password: false,
                            ),
                            const SizedBox(height: 20,),
                            CustomFormField(
                              label: "Email *",
                              controller: _emailController,
                              hint: "Entrez votre l'adresse électronique",
                              password: false,
                            ),
                            SizedBox(height: 20,),
                            CustomFormField(
                              label: "Mot de passe *",
                              controller: _passwordController,
                              hint: "Créez un mot de passe *",
                              password: true,
                              prefixIcon: Icon(Icons.lock_person_outlined),
                            ),
                            SizedBox(height: 20,),
                            CustomFormField(
                              label: "Confirmer le Mot de passe *",
                              controller: _confirmPasswordController,
                              hint: "Confirmer le mot de passe *",
                              password: true,
                              prefixIcon: Icon(Icons.lock_person_outlined),
                            ),
                            const SizedBox(height: 20,),
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
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.2),
                                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), topLeft: Radius.circular(30))
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset("packages/country_icons/icons/flags/png/${selectedPays!.codePays}.png", width: 30,),
                                        const SizedBox(width: 10,),
                                        Text(selectedPays!.paysIndictel.toString(), style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16
                                        ),),
                                        const Icon(Icons.arrow_drop_down)
                                      ],
                                    ),
                                  ),
                                  Flexible(child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(
                                      hintText: "Téléphone",
                                      labelText: "Téléphone",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), topRight: Radius.circular(30)),
                                      ),
                                      contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 10, right: 16),
                                    ),
                                    onTap: () {

                                    },
                                  ))
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            CustomFormField(
                              label: "Adresse complete *",
                              controller: _addressController,
                              hint: "Entrez votre adresse de domicile",
                              password: false,
                            ),
                            const SizedBox(height: 20,),
                            CustomFormField(
                              label: "Code de parrainage",
                              controller: _codeController,
                              hint: "Code de parrainage",
                              password: false,
                            ),
                            const SizedBox(height: 20,),
                            const Text("Les champs avec astérisque(*) sont obligatoire", style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                            ),),
                            const SizedBox(height: 20,),
                            RoundedButton(
                              title: "S'inscrire",
                              loading: authViewModel.loading,
                              onPress: () {
                                if (!authViewModel.loading) {
                                  if (_nomController.text.isEmpty) {
                                    Utils.flushBarErrorMessage("Vous devez entrer votre nom", context);
                                  } else if (_prenomController.text.isEmpty) {
                                    Utils.flushBarErrorMessage("Vous devez entrer votre préom", context);
                                  } else if (_addressController.text.isEmpty) {
                                    Utils.flushBarErrorMessage("Vous devez entrer votre adresse de résidence", context);
                                  } else if (_phoneController.text.isEmpty) {
                                    Utils.flushBarErrorMessage("Vous devez entrer votre numéro de téléphone", context);
                                  }  else if (_emailController.text.isEmpty) {
                                    Utils.flushBarErrorMessage("Vous devez entrer l'adresse mail", context);
                                  } else if (!EmailValidator.validate(_emailController.text)) {
                                    Utils.flushBarErrorMessage("Adresse e-mail invalide", context);
                                  } else if (_passwordController.text.isEmpty) {
                                    Utils.flushBarErrorMessage("Vous devez entrer le mot de passe", context);
                                  } else if (_passwordController.text.length < 6) {
                                    Utils.flushBarErrorMessage("Le mot de passe ne doit pas avoir moins de 6 carractères", context);
                                  }  else if (_passwordController.text != _confirmPasswordController.text) {
                                    Utils.flushBarErrorMessage("Les deux mot de passes ne correspondent pas", context);
                                  } else {
                                    Map data = {
                                      "username": _emailController.text,
                                      "nom": _nomController.text,
                                      "prenom": _prenomController.text,
                                      "email": _emailController.text,
                                      "idPays": selectedPays!.idPays,
                                      "adresse": _addressController.text,
                                      "telephone": selectedPays!.paysIndictel.toString() + _phoneController.text,
                                      "code_parrainage": _codeController.text,
                                      "password": _passwordController.text
                                    };

                                    authViewModel.registerApi(data, context);
                                  }
                                }
                              },
                            ),
                            const SizedBox(height: 20,),
                            const Text("Vous avez déjà un compte ?"),
                            const SizedBox(height: 10,),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, RoutesName.login);
                              }, child: Text("Connectez-vous", style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold
                            ),),),
                          ],
                        ),
                      )
                  );
              }
            })
    )
      ),
    );
  }
}