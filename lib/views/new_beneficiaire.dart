import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/model/pays_destination_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/NewBeneficiaireForm.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/views/contact_picker_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewBeneficiaireView extends StatefulWidget {
  Destination? destination;
  void Function()? updateSuccess;
  Map? fields;
  List? bankFieldsRequired;
  BeneficiaireModel? beneficiaireModel;
  bool? isFromTransfert;
  DemandesViewModel? parentDemandViewModel;
  void Function(BeneficiaireModel)? onBeneficiaireCreated;

  NewBeneficiaireView({
    Key? key,
    this.updateSuccess,
    this.destination,
    this.bankFieldsRequired,
    this.parentDemandViewModel,
    this.isFromTransfert,
    this.beneficiaireModel,
    this.fields,
    this.onBeneficiaireCreated,
  }) : super(key: key);

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
        appBar: CommonAppBar(
          context: context,
          backArrow: true,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: AppTexts.titleText(AppLocalizations.of(context)!.translate(widget.fields != null ? 'update_beneficiary_requirements' : 'newBeneficiary'))),
                  ],
                ),
              ),
              if (widget.fields != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Row(
                    children: [
                      Icon(Icons.person, size: 20, color: AppColors.primaryColor,), const SizedBox(width: 5,),
                      AppTexts.bodyText(widget.beneficiaireModel!.fullName(), bold: true, color: AppColors.primaryColor)
                    ],
                  ),
                ),
              const SizedBox(height: 10,),
              Expanded(
                child: SingleChildScrollView(
                  child: widget.fields == null ? ChangeNotifierProvider<DemandesViewModel>(
                    create: (BuildContext context) => demandesViewModel,
                    child: Consumer<DemandesViewModel>(builder: (context, value, _) {
                      switch (value.paysDestination.status) {
                        case Status.LOADING:
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: const Center(
                              child: CupertinoActivityIndicator(
                                color: Colors.black,
                              ),
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
                              destinations: paysDestinationModel!.destination!,
                              demandesViewModel: widget.parentDemandViewModel,
                              initialDestination: widget.destination,
                              parentCotext: context,
                              redirect: widget.isFromTransfert != true,
                              hideTitle: true,
                              fields: widget.fields,
                              bankFieldsRequired: widget.bankFieldsRequired,
                              onBeneficiaireCreated: widget.onBeneficiaireCreated,
                            ),
                          );
                      }
                    }),
                  ) : NewBeneficiaireForm(
                    beneficiaireModel: widget.beneficiaireModel,
                    parentCotext: context,
                    fields: widget.fields,
                    updateSucess: () {
                      widget.updateSuccess!();
                    },
                    onBeneficiaireCreated: widget.onBeneficiaireCreated,
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
