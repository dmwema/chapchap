import 'package:chapchap/res/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  bool showBack;
  bool red;

  CustomAppBar({Key? key, this.title, this.showBack = false, this.red = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          if (red)
            Container(
              width: 35, height: 35,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/logo.png"),
                  fit: BoxFit.contain
                )
              ),
            ),
          if (red)
            SizedBox(width: 10,),
          Text(title == null ? "" :title!, style: TextStyle(fontWeight: FontWeight.bold, color: !red ? Colors.black.withOpacity(.9): Colors.white.withOpacity(.9)),),
        ],
      ),
      elevation: 1,
      leading: Builder(builder: (BuildContext context) {
        if (showBack) {
          return IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: red ? Icon(Icons.chevron_left_rounded, color: Colors.white, size: 40,): Image.asset("assets/back.png")
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
      actions: [
        if (!red)
          const CircleAvatar(
            backgroundColor: Colors.red,
            backgroundImage: AssetImage("assets/avatart.jpeg"),
          ),
        SizedBox(width: 20,)
      ],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(0)
          )
      ),
      backgroundColor: red ? AppColors.primaryColor: Colors.white,
      iconTheme: IconThemeData(
          color: Colors.white
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}