import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/rounded_button.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/model/user_model.dart';

class ConfirmDelete extends StatelessWidget {
  final int recipientId;
  final DemandesViewModel  demandesViewModel;

  const ConfirmDelete({Key? key, required this.recipientId, required this.demandesViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error,
            color: Colors.black54,
            size: 50,
          ),
          const SizedBox(height: 10,),
          Column(
            children: const [
              Text("Voulez-vous vraiment supprimer ce bénéficiaire ?",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedButton(
                onPress: () {
                  demandesViewModel.deleteRecipient(context, recipientId);
                },
                title: "Supprimer",
                loading: demandesViewModel.loading,
              ),
              const SizedBox(width: 10,),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      border: Border.all(color: AppColors.primaryColor, width: 2)
                  ),
                  child: Text("Annuler", style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor
                  ),),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}