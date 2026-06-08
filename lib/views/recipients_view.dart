import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/beneficiaire_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/recipient_card2.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/views/send_view.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RecipientsView extends StatefulWidget {
  const RecipientsView({Key? key}) : super(key: key);

  @override
  State<RecipientsView> createState() => _RecipientsViewState();
}

class _RecipientsViewState extends State<RecipientsView> with SingleTickerProviderStateMixin {
  DemandesViewModel demandesViewModel = DemandesViewModel();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);

    demandesViewModel.beneficiaires([], context);
  }

  final TextEditingController _searchBeneficiaireController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _searchBeneficiaireController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.bgColor,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
            systemNavigationBarDividerColor: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               const SizedBox(height: 20,),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     AppTexts.titleText(AppLocalizations.of(context)!.translate('beneficiaries')),
                     const SizedBox(width: 10,),
                     GestureDetector(
                       onTap: () {
                         Navigator.pushNamed(context, RoutesName.newBeneficiaire);
                       },
                       child: Container(
                         width: 20, height: 20,
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(50),
                             color: AppColors.primaryColor
                         ),
                         child: const Center(
                           child: Icon(CupertinoIcons.add, size: 15, color: Colors.white,),
                         ),
                       ),
                     )
                   ],
                 ),
               ),
               const SizedBox(height: 10,),
               InkWell(
                 onTap: () {
                   Navigator.pushNamed(context, RoutesName.recipeintsArchive);
                 },
                 child: Container(
                     padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                     decoration: BoxDecoration(
                         border: Border(
                           bottom: BorderSide(color: AppColors.formFieldColor, width: 1),
                           top: BorderSide(color: AppColors.formFieldColor, width: 1),
                         )
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             const Icon(CupertinoIcons.archivebox_fill, size: 20,),
                             const SizedBox(width: 10,),
                             AppTexts.smallText(AppLocalizations.of(context)!.translate('archived_beneficiaries'))
                           ],
                         ),
                       ],
                     )
                 ),
               ),
               const SizedBox(height: 20,),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
                 child: TextField(
                   controller: _searchBeneficiaireController,
                   decoration: InputDecoration(
                     hintText: AppLocalizations.of(context)!.translate("search") ?? "Rechercher un bénéficiaire",
                     prefixIcon: const Icon(Icons.search),
                     suffixIcon: _searchBeneficiaireController.text.isNotEmpty
                         ? IconButton(
                       icon: const Icon(Icons.clear),
                       onPressed: () {
                         setState(() {
                           _searchBeneficiaireController.clear();
                         });
                       },
                     )
                         : null,
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8),
                       borderSide: BorderSide(color: AppColors.formFieldBorderColor),
                     ),
                     enabledBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8),
                       borderSide: BorderSide(color: AppColors.formFieldBorderColor),
                     ),
                     focusedBorder: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(8),
                       borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                     ),
                     contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                     filled: true,
                     fillColor: Colors.white,
                   ),
                   onChanged: (value) {
                     setState(() {});
                   },
                 ),
               ),
               const SizedBox(height: 20,),
               Expanded(child: ChangeNotifierProvider<DemandesViewModel>(
                   create: (BuildContext context) => demandesViewModel,
                   child: Consumer<DemandesViewModel>(
                       builder: (context, value, _){
                         switch (value.beneficiairesList.status) {
                           case Status.LOADING:
                             return SizedBox(
                               height: MediaQuery.of(context).size.height - 200,
                               child: const Center(
                                 child: CupertinoActivityIndicator(color: Colors.black,),
                               ),
                             );
                           case Status.ERROR:
                             return Center(
                               child: Text(value.beneficiairesList.message.toString()),
                             );
                           default:
                             if (value.beneficiairesList.data!.length == 0) {
                               return Center(
                                 child: AppTexts.descriptionText(AppLocalizations.of(context)!.translate('no_beneficiaries')),
                               );
                             }

                             List data = [];
                             if (value.beneficiairesList.data!.length > 0) {
                               value.beneficiairesList.data!.forEach((element) {
                                 if (element != null) {
                                   BeneficiaireModel ben = BeneficiaireModel.fromJson(element);
                                   data.add(ben);
                                 }
                               });
                             }

                             List filteredData = data.where((element) {
                               String searchText = _searchBeneficiaireController.text.toLowerCase();
                               return element.nomBeneficiaire!.toLowerCase().contains(searchText) ||
                                   element.telBeneficiaire!.toLowerCase().contains(searchText);
                             }).toList();

                             return Column(
                               children: [
                                 if (filteredData.isEmpty && _searchBeneficiaireController.text.isNotEmpty)
                                   Expanded(
                                     child: Center(
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           Icon(Icons.search_off, size: 60, color: Colors.black.withOpacity(.2)),
                                           const SizedBox(height: 10),
                                           Text(
                                             AppLocalizations.of(context).translate("no_results_found") ?? "Aucun résultat trouvé",
                                             style: TextStyle(
                                               color: Colors.black.withOpacity(.3),
                                               fontSize: 16,
                                             ),
                                           ),
                                         ],
                                       ),
                                     ),
                                   ),
                                 if (filteredData.isNotEmpty)
                                  Expanded(
                                   child: ListView.builder(
                                     itemCount: value.beneficiairesList.data!.length,
                                     itemBuilder: (context, index) {
                                       if (value.beneficiairesList.data![index] != null) {
                                         BeneficiaireModel current = BeneficiaireModel.fromJson(value.beneficiairesList.data![index]);
                                         return InkWell(
                                             onTap: (){
                                               DemandesViewModel demandesViewModel2 = DemandesViewModel();
                                               demandesViewModel2.beneficiaireInfo(current.idBeneficiaire!.toInt(), context);
                                               showModalBottomSheet(
                                                 context: context,
                                                 isScrollControlled: true,
                                                 backgroundColor: AppColors.bgColor,
                                                 builder: (context) {
                                                   return ChangeNotifierProvider<DemandesViewModel>(
                                                       create: (BuildContext context) => demandesViewModel2,
                                                       child: Consumer<DemandesViewModel>(
                                                           builder: (context, value, _){
                                                             switch (value.beneficiaireModel.status) {
                                                               case Status.LOADING:
                                                                 return const SizedBox(
                                                                   height: 200,
                                                                   child: Center(
                                                                     child: CupertinoActivityIndicator(color: Colors.black,),
                                                                   ),
                                                                 );
                                                               case Status.ERROR:
                                                                 return Center(
                                                                   child: Text(value.beneficiairesList.message.toString()),
                                                                 );
                                                               default:
                                                                 BeneficiaireModel beneficiaire = value.beneficiaireModel.data!;
                                                                 return SafeArea(
                                                                   child: Container(
                                                                     padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 40),
                                                                     child: Column(
                                                                       mainAxisSize: MainAxisSize.min,
                                                                       crossAxisAlignment: CrossAxisAlignment.center,
                                                                       mainAxisAlignment: MainAxisAlignment.center,
                                                                       children:  [
                                                                         CircularProfileAvatar(
                                                                           "",
                                                                           radius: 25, // sets radius, default 50.0
                                                                           backgroundColor: AppColors.primaryColor.withOpacity(.4), // sets background color, default Colors.white
                                                                           initialsText: Text(
                                                                             beneficiaire.initials(),
                                                                             style: TextStyle(fontSize: 16, color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                                                                           ),
                                                                           elevation: 2.0, // sets elevation (shadow of the profile picture), default value is 0.0
                                                                           foregroundColor: Colors.brown.withOpacity(0.5),
                                                                           cacheImage: true,
                                                                           showInitialTextAbovePicture: false,
                                                                         ),
                                                                         const SizedBox(height: 10,),
                                                                         AppTexts.titleText(beneficiaire.fullName()),
                                                                         AppTexts.descriptionText(beneficiaire.telBeneficiaire.toString()),
                                                                         const SizedBox(height: 20,),
                                                                         Row(
                                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                           children: [
                                                                             AppTexts.smallText(AppLocalizations.of(context)!.translate('country')),
                                                                             Row(
                                                                               children: [
                                                                                 Image.asset("packages/country_icons/icons/flags/png/${beneficiaire.codePays}.png", width: 30, height: 15, fit: BoxFit.contain),
                                                                                 const SizedBox(width: 5,),
                                                                                 AppTexts.smallText("(${beneficiaire.paysMonnaie})"),
                                                                               ],
                                                                             )
                                                                           ],
                                                                         ),
                                                                         const SizedBox(height: 5,),
                                                                         Divider(color: AppColors.formFieldColor,),
                                                                         Row(
                                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                           children: [
                                                                             AppTexts.smallText(AppLocalizations.of(context)!.translate('email')),
                                                                             AppTexts.smallText(beneficiaire.emailBeneficiaire.toString()),
                                                                           ],
                                                                         ),
                                                                         Divider(color: AppColors.formFieldColor,),
                                                                         Row(
                                                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                           children: [
                                                                             AppTexts.smallText(AppLocalizations.of(context)!.translate('phone')),
                                                                             AppTexts.smallText(beneficiaire.telBeneficiaire.toString()),
                                                                           ],
                                                                         ),
                                                                         const SizedBox(height: 20,),
                                                                         Wrap(
                                                                           spacing: 5,
                                                                           runSpacing: 5,
                                                                           crossAxisAlignment: WrapCrossAlignment.center,
                                                                           alignment: WrapAlignment.spaceBetween,
                                                                           children: [
                                                                             RoundedButton(
                                                                               title: AppLocalizations.of(context)!.translate('new_transfer'),
                                                                               onPress: () {
                                                                                 Navigator.push(
                                                                                   context,
                                                                                   MaterialPageRoute(builder: (context) => SendView(
                                                                                     beneficiaire: beneficiaire,
                                                                                     selectedDestination: beneficiaire.destination,
                                                                                     destination: beneficiaire.codePays,
                                                                                   )),
                                                                                 );
                                                                               },
                                                                               icon: CupertinoIcons.arrow_up_right,
                                                                               color: AppColors.buttonBlackColor,
                                                                               textColor: Colors.white,
                                                                             ),
                                                                             RoundedButton(
                                                                               title: AppLocalizations.of(context)!.translate('archive'),
                                                                               onPress: () {
                                                                                 DemandesViewModel demandesViewModel3 = DemandesViewModel();
                                                                                 showCupertinoDialog(
                                                                                   context: context,
                                                                                   builder: (BuildContext context) {
                                                                                     return CupertinoAlertDialog(
                                                                                       title: Text(AppLocalizations.of(context)!.translate('confirm')),
                                                                                       content: Text(AppLocalizations.of(context)!.translate('archive_confirmation')),
                                                                                       actions: [
                                                                                         CupertinoDialogAction(
                                                                                           child: const Text('Annuler', style: TextStyle(
                                                                                               color: Colors.black
                                                                                           ),),
                                                                                           onPressed: () {
                                                                                             Navigator.of(context).pop(); // Fermer le dialogue
                                                                                           },
                                                                                         ),
                                                                                         CupertinoDialogAction(
                                                                                           child: Text(AppLocalizations.of(context)!.translate('confirm'), style: TextStyle(
                                                                                               color: AppColors.primaryColor
                                                                                           ),),
                                                                                           onPressed: () async {
                                                                                             Navigator.of(context).pop();
                                                                                             Navigator.of(context).pop();
                                                                                             await demandesViewModel.archiveRecipient(context, beneficiaire.idBeneficiaire!.toInt()).then((value) {
                                                                                               setState(() {
                                                                                                 demandesViewModel.beneficiaires([], context);
                                                                                               });
                                                                                             });// Fermer le dialogue
                                                                                           },
                                                                                         ),
                                                                                       ],
                                                                                     );
                                                                                   },
                                                                                 );
                                                                               },
                                                                               icon: CupertinoIcons.archivebox,
                                                                               color: AppColors.buttonBlackColor,
                                                                               textColor: Colors.white,
                                                                             ),
                                                                             RoundedButton(
                                                                               title: AppLocalizations.of(context)!.translate('delete'),
                                                                               onPress: () {
                                                                                 showCupertinoDialog(
                                                                                   context: context,
                                                                                   builder: (BuildContext context) {
                                                                                     return CupertinoAlertDialog(
                                                                                       title: Text(AppLocalizations.of(context)!.translate('confirm')),
                                                                                       content: Text(AppLocalizations.of(context)!.translate('delete_confirmation')),
                                                                                       actions: [
                                                                                         CupertinoDialogAction(
                                                                                           child: const Text('Annuler', style: TextStyle(
                                                                                               color: Colors.black
                                                                                           ),),
                                                                                           onPressed: () {
                                                                                             Navigator.of(context).pop(); // Fermer le dialogue
                                                                                           },
                                                                                         ),
                                                                                         CupertinoDialogAction(
                                                                                           child: Text(AppLocalizations.of(context)!.translate('confirm'), style: TextStyle(
                                                                                               color: AppColors.primaryColor
                                                                                           ),),
                                                                                           onPressed: () async {
                                                                                             Navigator.of(context).pop();
                                                                                             Navigator.of(context).pop();

                                                                                             BuildContext modalContext = context;

                                                                                             await demandesViewModel.deleteRecipient(context, beneficiaire.idBeneficiaire!.toInt()).then((value) {
                                                                                               if (value) {
                                                                                                 setState(() {
                                                                                                   demandesViewModel.beneficiaires([], context);
                                                                                                 });
                                                                                               }
                                                                                             });
                                                                                           },
                                                                                         ),
                                                                                       ],
                                                                                     );
                                                                                   },
                                                                                 );
                                                                               },
                                                                               icon: CupertinoIcons.delete,
                                                                               color: AppColors.buttonBlackColor,
                                                                               textColor: Colors.white,
                                                                             ),
                                                                           ],
                                                                         )
                                                                       ],
                                                                     ),
                                                                   ),
                                                                 );
                                                             }
                                                           })
                                                   );
                                                 },
                                                 shape: const RoundedRectangleBorder(
                                                   borderRadius: BorderRadius.vertical(
                                                     top: Radius.circular(0),
                                                   ),
                                                 ),
                                               );
                                             },
                                             child: Column(
                                               children: [
                                                 RecipientCard2(
                                                   name: current.fullName(),
                                                   address: current.codePays.toString(),
                                                   phone: current.telBeneficiaire.toString(),
                                                   initials: current.initials(),
                                                 ),
                                               ],
                                             )
                                         );
                                       }
                                       return Container();
                                     },
                                   ),
                                 ),
                               ],
                             );
                         }
                       })
               ))
             ],
          ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:ScaleTransition(
        scale: _animation,
        child: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)
          ),
          onPressed: () {
            Navigator.pushNamed(context, RoutesName.send);
          },
          child: const Icon(CupertinoIcons.arrow_up_right_circle, color: Colors.white, size: 35,),
        ),
      ),
      bottomNavigationBar: commonBottomAppBar(context: context, active: 1),
    );
  }
}