
import 'package:chapchap/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chapchap/model/user_model.dart';
import 'package:chapchap/res/app_url.dart';
import 'package:chapchap/res/app_colors.dart';
import 'package:chapchap/res/components/custom_appbar.dart';
import 'package:chapchap/res/components/profile_menu.dart';
import 'package:chapchap/utils/routes/routes_name.dart';
import 'package:chapchap/view_model/user_view_model.dart';

class ContactView extends StatefulWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  UserModel? user;
  int counter = 0;
  var profilePhoto;

  @override
  void initState() {
    // TODO: implement initState
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: user != null ? CustomAppBar(
          title: "Nos contacts",
          showBack: true,
        ): null,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileMenu(
                  title: "+1 514 370 1555 (Canada)",
                  icon: Icons.phone,
                  noIcon: true,
                  onTap: () {
                    //Navigator.pushNamed(context, RoutesName.personnal_informations);
                  },
                ),
                ProfileMenu(
                  title: "+1 438 492 9679 (Canada)",
                  icon: Icons.phone,
                  noIcon: true,
                  onTap: () {
                    //Navigator.pushNamed(context, RoutesName.personnal_informations);
                  },
                ),
                ProfileMenu(
                  title: "+225 05 74 454 802 (Côte d'Ivoire)",
                  icon: Icons.phone,
                  noIcon: true,
                  onTap: () {
                    //Navigator.pushNamed(context, RoutesName.personnal_informations);
                  },
                ),
                ProfileMenu(
                  title: "+226 70 06 06 42 (Burkina Faso)",
                  icon: Icons.phone,
                  noIcon: true,
                  onTap: () {
                    //Navigator.pushNamed(context, RoutesName.personnal_informations);
                  },
                ),
                ProfileMenu(
                  title: "+237 6 97 23 09 57 (Cameroun)",
                  icon: Icons.phone,
                  noIcon: true,
                  onTap: () {
                    //Navigator.pushNamed(context, RoutesName.personnal_informations);
                  },
                ),
                ProfileMenu(
                  title: "support@chapchap.ca",
                  icon: Icons.alternate_email_sharp,
                  noIcon: true,
                  onTap: () {
                    //Navigator.pushNamed(context, RoutesName.personnal_informations);
                  },
                ),
                ProfileMenu(
                  title: "8304 Chemin Devonshire, Mont-Royal, H4P 2P7, QC, Canada Suite 260",
                  icon: Icons.map_outlined,
                  noIcon: true,
                  onTap: () {
                    //Navigator.pushNamed(context, RoutesName.personnal_informations);
                  },
                ),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        )
    );
  }
}