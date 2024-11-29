import 'dart:ui';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InteracView extends StatefulWidget {
  const InteracView({Key? key}) : super(key: key);

  @override
  State<InteracView> createState() => _InteracViewState();
}

class _InteracViewState extends State<InteracView> {
  UserModel? user;

  bool showCode = true;
  bool showResponse = true;

  @override
  void initState() {
    super.initState();
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Informations interac", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black), textAlign: TextAlign.left,),
              ),
              const SizedBox(height: 20,),
              if (user != null && user!.codeInterac != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("code interac", style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500
                        ),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ImageFiltered(
                              imageFilter: ImageFilter.blur(sigmaX: showCode ? 5 : 0, sigmaY: showCode ? 5 : 0),
                              child: Text(user!.codeInterac.toString(), style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  showCode = !showCode;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.primaryColor
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Row(
                                  children: [
                                    Icon(showCode ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill, color: Colors.white, size: 15,),
                                    const SizedBox(width: 5,),
                                    Text(showCode ? "afficher" : "Cacher", style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12
                                    ),),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20,),
                        const Text("Question interac", style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500
                        ),),
                        Text(user!.questionInterac.toString(), style: const TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),),
                        const SizedBox(height: 20,),
                        const Text("Reponse interac", style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500
                        ),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ImageFiltered(
                              imageFilter: ImageFilter.blur(sigmaX: showResponse ? 5 : 0, sigmaY: showResponse ? 5 : 0),
                              child: Text(user!.reponseInterac.toString(), style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  showResponse = !showResponse;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.primaryColor
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Row(
                                  children: [
                                    Icon(showResponse ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill, color: Colors.white, size: 15,),
                                    const SizedBox(width: 5,),
                                    Text(showResponse ? "afficher" : "Cacher", style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12
                                    ),),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )



    );
  }
}