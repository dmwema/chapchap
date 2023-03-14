import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/demande_model.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/NewBeneficiaireForm.dart';
import 'package:chapchap/res/components/appbar_drawer.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/history_card.dart';
import 'package:chapchap/res/components/home_card.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewBeneficiaireView extends StatefulWidget {
  const NewBeneficiaireView({Key? key}) : super(key: key);

  @override
  State<NewBeneficiaireView> createState() => _NewBeneficiaireViewState();
}

class _NewBeneficiaireViewState extends State<NewBeneficiaireView> {
  DemandesViewModel demandesViewModel = DemandesViewModel();
  PaysDestinationModel? paysDestinationModel;

  @override
  void initState() {
    super.initState();
    demandesViewModel.paysDestinations([], context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "Ajouter bénéficiaire",
          showBack: true,
          backUrl: RoutesName.recipeints,
        ),
        drawer: const AppbarDrawer(),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: ChangeNotifierProvider<DemandesViewModel>(
                create: (BuildContext context) => demandesViewModel,
                child: Consumer<DemandesViewModel>(
                    builder: (context, value, _){
                      switch (value.paysDestination.status) {
                        case Status.LOADING:
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: Center(
                              child: CircularProgressIndicator(color: AppColors.primaryColor,),
                            ),
                          );
                        case Status.ERROR:
                          return Center(
                            child: Text(value.paysDestination.message.toString()),
                          );
                        default:
                          paysDestinationModel = value.paysDestination.data!;
                          return Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: NewBeneficiaireForm(
                                destinations: paysDestinationModel!.destination!, parentCotext: context, redirect: true,
                              )
                          );
                      }
                    })
            )
        )
    );
  }
}