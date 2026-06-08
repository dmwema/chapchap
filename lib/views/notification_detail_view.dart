import 'dart:ui';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationDetailView extends StatefulWidget {
  int id;
  String title;
  String description;
  String date;
  String? imagePath;
  bool read;
  NotificationDetailView({required this.title, required this.read, required this.id, required this.description, required this.date, this.imagePath, Key? key}) : super(key: key);

  @override
  State<NotificationDetailView> createState() => _NotificationDetailViewState();
}

class _NotificationDetailViewState extends State<NotificationDetailView> {
  UserModel? user;

  bool showCode = true;
  bool showResponse = true;

  DemandesViewModel demandesViewModel = DemandesViewModel();

  @override
  void initState() {
    super.initState();
    demandesViewModel.readNotification(context, widget.id);
    UserViewModel().reduceNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyBordContainer(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: CommonAppBar(
          context: context,
          backArrow: true,
          // title: "Notifications",
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.imagePath != null)
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage(widget.imagePath!), fit: BoxFit.cover),
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                  const SizedBox(height: 20,),
                  AppTexts.titleText(widget.title),
                  const SizedBox(height: 5,),
                  AppTexts.cardDescription(widget.date),
                  const SizedBox(height: 10,),
                  AppTexts.descriptionText(widget.description),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
        // floatingActionButton: commonSendBtn(context),
      ),
    );
  }
}