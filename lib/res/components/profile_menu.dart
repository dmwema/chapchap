import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  final String title;
  final IconData icon;
  void Function()? onTap;
  Color? color;
  bool? download;
  bool? noIcon;
  int? count;

  ProfileMenu({Key? key, required this.title, required this.icon, this.onTap, this.download = false, this.count, this.color, this.noIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: color ?? Colors.black54,),
            const SizedBox(width: 10,),
            Flexible(child: Text(title.toString(), style: const TextStyle(color: Colors.black54),),),
            noIcon != null && noIcon! == true ? Container(): download! ? const Icon(Icons.download_outlined, color: Colors.black45,)
              : (count == null ? const Icon(Icons.chevron_right_outlined, color: Colors.black45,)
              : Text(count.toString()))
          ],
        ),
      ),
    );
  }
}