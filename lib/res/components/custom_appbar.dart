import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/view_model/user_view_model.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final String? title;
  bool showBack;
  bool red;
  String? backUrl;
  CustomAppBar({Key? key, this.title, this.showBack = false, this.red = false, this.backUrl}) : super(key: key);

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
            const SizedBox(width: 10,),
          Text(title ?? "", style: TextStyle(fontWeight: FontWeight.bold, color: !red ? Colors.black.withOpacity(.9): Colors.white.withOpacity(.9)),),
        ],
      ),
      elevation: 1,
      leading: Builder(builder: (BuildContext context) {
        if (showBack) {
          return IconButton(
              onPressed: () {
                if (widget.backUrl != null)  {
                  Navigator.pushNamed(context, widget.backUrl.toString());
                } else {
                  Navigator.pop(context);
                  }
              },
              icon: red ? const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 40,): Image.asset("assets/back.png")
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
        if (!red && user != null && user!.photoProfil  != null)

          CircularProfileAvatar(
            user!.photoProfil.toString(),
            radius: 20, // sets radius, default 50.0
            initialsText: Text(
              "CC",
              style: TextStyle(fontSize: 16, color: AppColors.primaryColor, fontWeight: FontWeight.bold),
            ),  // sets initials text, set your own style, default Text('')
            elevation: 2.0, // sets elevation (shadow of the profile picture), default value is 0.0
            foregroundColor: Colors.brown.withOpacity(0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
            cacheImage: true, // allow widget to cache image against provided url
            showInitialTextAbovePicture: false, // setting it true will show initials text above profile picture, default false
          ),
        const SizedBox(width: 20,)
      ],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(0)
          )
      ),
      backgroundColor: red ? AppColors.primaryColor: Colors.white,
      iconTheme: const IconThemeData(
          color: Colors.white
      ),
    );
  }

}