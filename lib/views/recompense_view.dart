
import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RecomenseView extends StatefulWidget {
  const RecomenseView({Key? key}) : super(key: key);


  @override
  State<RecomenseView> createState() => _RecomenseViewState();
}

class _RecomenseViewState extends State<RecomenseView> {
  UserModel? user;
  DemandesViewModel demandesViewModel = DemandesViewModel();

  @override
  void initState() {
    demandesViewModel.myPromos(context);
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  bool loadEmail = false;
  bool loadSMS = false;

  Future<void> _openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      setState(() {
        loadEmail = false;
        loadSMS = false;
      });
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.formFieldColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonAppBar(
                  context: context,
                  backArrow: true
              ),
              const SizedBox(height: 10,),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Recompenses", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 5),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(CupertinoIcons.gift_fill, color: AppColors.primaryColor, size: 60,),
                        const SizedBox(height: 10),
                        Text(
                          "${user!.soldeParrainage} ${user!.paysMonnaie ?? ''}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        SizedBox(
                          width: 230,
                          child: Flexible(
                            child: Text(
                              "Vous avez ${user!.soldeParrainage} ${user!.paysMonnaie ?? ''} comme solde de parrainage.",
                              style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}