import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  bool showBack;
  bool red;
  bool showHelp;
  String? backUrl;
  CustomAppBar({Key? key, this.title, this.showHelp = true, this.showBack = false, this.red = false, this.backUrl}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  UserModel? user;

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
    final String? title = widget.title;
    bool showBack = widget.showBack;
    bool red = widget.red;
    bool showHelp = widget.showHelp;

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showBack)
                IconButton(
                    onPressed: () {
                      if (widget.backUrl != null)  {
                        Navigator.pushNamed(context, widget.backUrl.toString());
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(CupertinoIcons.back, color: Colors.black, size: 20,)
                ),
                if (showHelp)
                  Expanded(child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                      },
                      child: IconButton(
                        onPressed: () {

                        },
                        icon: const Icon(CupertinoIcons.question_circle, color: Colors.black, size: 20,),
                      ),
                    ),
                  ))
              ],
            ),
          ),
          //Padding(
          //  padding: const EdgeInsets.symmetric(horizontal: 20),
          //  child: Text(title ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black), textAlign: TextAlign.left,),
          //),
        ],
      ),
    );
  }

}