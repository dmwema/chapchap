import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/NewBeneficiaireForm.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewBeneficiaireView extends StatefulWidget {
  Destination? destination;
  DemandesViewModel? parentDemandViewModel;
  NewBeneficiaireView({Key? key, this.destination, this.parentDemandViewModel}) : super(key: key);

  @override
  State<NewBeneficiaireView> createState() => _NewBeneficiaireViewState();
}

class _NewBeneficiaireViewState extends State<NewBeneficiaireView> {
  DemandesViewModel demandesViewModel = DemandesViewModel();
  PaysDestinationModel? paysDestinationModel;

  @override
  void initState() {
    super.initState();
    demandesViewModel.myDestinationsApi([], context);
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyBordContainer(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        resizeToAvoidBottomInset: false,
        appBar: CommonAppBar(context: context, backArrow: true, title: "Nouveau bénéficiaire",),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: pageTitleStyle(title: "ça ne vous prendra que 30 secondes ;)", context: context),
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: SingleChildScrollView(
                  child: ChangeNotifierProvider<DemandesViewModel>(
                    create: (BuildContext context) => demandesViewModel,
                    child: Consumer<DemandesViewModel>(
                          builder: (context, value, _){
                            switch (value.paysDestination.status) {
                              case Status.LOADING:
                                return SizedBox(
                                  height: MediaQuery.of(context).size.height - 200,
                                  child: const Center(
                                    child: CupertinoActivityIndicator(color: Colors.black,),
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
                                      destinations: paysDestinationModel!.destination!, demandesViewModel: widget.parentDemandViewModel, initialDestination: widget.destination, parentCotext: context, redirect: true,
                                      hideTitle: true,
                                    )
                                );
                            }
                          })
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}