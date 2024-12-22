import 'dart:ui';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/info_card.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsView extends StatefulWidget {
  List notifications;
  NotificationsView({Key? key, required this.notifications}) : super(key: key);

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
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
        backgroundColor: AppColors.bgColor,
        appBar: CommonAppBar(context: context, backArrow: true,),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppTexts.titleText("Notifications"),
              ),
              const SizedBox(height: 20,),
              if (user != null && user!.codeInterac != null)
              SingleChildScrollView(
                child: Column(
                  children: List.generate(widget.notifications.length, (index) {
                    Map current = widget.notifications[index];
                    return InfoCard(type: current['type_msg_info'], content: current['msg']);
                  }),
                ),
              )
            ],
          ),
        )



    );
  }
}