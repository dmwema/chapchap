import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/appbar_drawer.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/recipient_card2.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipientsView extends StatefulWidget {
  const RecipientsView({Key? key}) : super(key: key);

  @override
  State<RecipientsView> createState() => _RecipientsViewState();
}

class _RecipientsViewState extends State<RecipientsView> {
  DemandesViewModel demandesViewModel = DemandesViewModel();

  @override
  void initState() {
    super.initState();
    demandesViewModel.beneficiaires([], context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {  },
        child: const Center(
          child: Icon(Icons.person_add_alt_1),
        ),
      ),
        appBar: CustomAppBar(
          showBack: true,
          title: "Bénéficiaires",
          backUrl: RoutesName.home,
        ),
        drawer: const AppbarDrawer(),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: ChangeNotifierProvider<DemandesViewModel>(
            create: (BuildContext context) => demandesViewModel,
            child: Consumer<DemandesViewModel>(
                builder: (context, value, _){
                  switch (value.beneficiairesList.status) {
                    case Status.LOADING:
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 200,
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors.primaryColor,),
                        ),
                      );
                    case Status.ERROR:
                      return Center(
                        child: Text(value.beneficiairesList.message.toString()),
                      );
                    default:
                      if (value.beneficiairesList.data!.length == 0) {
                        return Center(
                          child: Text(
                            "Aucun bénéficiaire enrégistré",
                            style: TextStyle(
                              color: Colors.black.withOpacity(.2),
                            ),
                          ),
                        );
                      }
                      return Padding(
                          padding: const EdgeInsets.all(20),
                          child: ListView.builder(
                            itemCount: value.beneficiairesList.data!.length,
                            itemBuilder: (context, index) {
                              BeneficiaireModel current = BeneficiaireModel.fromJson(value.beneficiairesList.data![index]);
                              return Column(
                                children: [
                                  RecipientCard2(
                                    name: "${current.nomBeneficiaire} (${current.codePays})",
                                    address: current.codePays.toString(),
                                    phone: current.telBeneficiaire.toString(),
                                  ),
                                  const SizedBox(height: 20,)
                                ],
                              );
                            },
                          )
                      );
                  }
                })
        )
    );
  }
}