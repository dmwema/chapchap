import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/NewBeneficiaireForm.dart';
import 'package:chapchap/res/components/recipient_card2.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewRecipientView extends StatefulWidget {
  const NewRecipientView({Key? key}) : super(key: key);

  @override
  State<NewRecipientView> createState() => _NewRecipientViewState();
}

class _NewRecipientViewState extends State<NewRecipientView> {
  DemandesViewModel demandesViewModel = DemandesViewModel();

  @override
  void initState() {
    super.initState();
    demandesViewModel.beneficiairesArchive([], context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.formFieldColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonAppBar(
                context: context,
                backArrow: true,
                backClick: () {
                  Navigator.pushNamed(context, RoutesName.recipeints);
                }
            ),
            const SizedBox(height: 20,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Nouveau bénéficiaire", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: NewBeneficiaireForm(
                destinations: [],
                parentCotext: context,
              )
            )
          ],
        ),
      ),
    );
  }
}