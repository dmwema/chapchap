import 'package:chapchap/res/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  bool showBack;

  CustomAppBar({Key? key, this.title, this.showBack = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title == null ? "" :title!, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white.withOpacity(.9)),),
      elevation: 0,
      leading: Builder(builder: (BuildContext context) {
        if (showBack) {
          return IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Image.asset("assets/back.png")
          );
        }
        return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Image.asset("assets/menu.png")
        );
      },
      ),
      actions: const [
        CircleAvatar(
          backgroundColor: Colors.red,
          child: Text("AS"),
        ),
        SizedBox(width: 20,)
      ],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(0)
          )
      ),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
          color: Colors.white
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}