import 'dart:ui';

import 'package:chapchap/common/common_widgets.dart';
import 'package:chapchap/l10n/app_localizations.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/data/response/status.dart';
import 'package:chapchap/res/app_texts.dart';
import 'package:chapchap/res/components/hide_keyboard_container.dart';
import 'package:chapchap/res/components/info_card.dart';
import 'package:chapchap/view_model/demandes_view_model.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:chapchap/views/notification_detail_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class NotificationsView extends StatefulWidget {
  // bool problems;
  NotificationsView({Key? key}) : super(key: key);

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  UserModel? user;

  bool showCode = true;
  bool showResponse = true;

  DemandesViewModel demandesViewModel = DemandesViewModel();

  @override
  void initState() {
    super.initState();
    demandesViewModel.notifications(context);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTexts.titleText(AppLocalizations.of(context)!.translate('notifications')), // Traduction du titre
                  ],
                ),
              ),
              Expanded(
                child: ChangeNotifierProvider<DemandesViewModel>(
                    create: (BuildContext context) => demandesViewModel,
                    child: Consumer<DemandesViewModel>(
                        builder: (context, value, _){
                          switch (value.notificationsList.status) {
                            case Status.LOADING:
                              return const SizedBox(
                                child: Center(
                                  child: CupertinoActivityIndicator(color: Colors.black,),
                                ),
                              );
                            case Status.ERROR:
                              return Center(
                                child: AppTexts.descriptionText(value.paysActifList.message.toString()),
                              );
                            default:
                              final notificationsList = value.notificationsList.data!;
                              Map<String, List<Map>> groupedNotification = {};
                              for (var notification in notificationsList) {
                                Map current = notification;
                                DateTime date = DateFormat("yyyy-MM-dd HH:mm:ss").parse(current['date']);
                                String monthYear = DateFormat("MMMM yyyy").format(date);

                                if (!groupedNotification.containsKey(monthYear)) {
                                  groupedNotification[monthYear] = [];
                                }
                                groupedNotification[monthYear]!.add(current);
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: groupedNotification.keys.length,
                                      itemBuilder: (context, index) {
                                        String monthYear = groupedNotification.keys.elementAt(index);
                                        List<Map> notifications = groupedNotification[monthYear]!;

                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20, bottom: 10.0, right: 20, left: 20),
                                              child: AppTexts.smallButtonText(
                                                  monthYear,
                                                  color: AppColors.buttonBlackColor
                                              ),
                                            ),
                                            Column(
                                              children: List.generate(notifications.length, (index) {
                                                bool read = notifications[index]['read'] ?? false;
                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      notifications[index]['read'] = true;
                                                    });
                                                    Navigator.push(context, CupertinoPageRoute(builder: (route)
                                                    => NotificationDetailView(
                                                      id: notifications[index]['id'],
                                                      title: notifications[index]['title'].toString(),
                                                      description: notifications[index]['body'],
                                                      imagePath: notifications[index]['url_img'],
                                                      date: notifications[index]['date'],
                                                      read: read,
                                                    ))
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: Colors.white,
                                                        border: read ? null : Border(left: BorderSide(width: 3, color: AppColors.primaryColor)),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Color.fromRGBO(0, 0, 0, 0.1),
                                                            blurRadius: 12,
                                                            spreadRadius: 0,
                                                            offset: Offset(0, 4),
                                                          ),
                                                        ]
                                                    ),
                                                    margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                                                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              AppTexts.cardTitle(notifications[index]['title'].toString(), color: read ? Colors.black : AppColors.primaryColor, bold: !read),
                                                              AppTexts.smallText(notifications[index]['body'].toString(), color: AppColors.textGrey),
                                                            ],
                                                          ),
                                                        ),
                                                        const Icon(Icons.more_horiz)
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                          }
                        })
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}