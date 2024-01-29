import 'package:chapchap/res/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  final String title;
  final IconData icon;
  void Function()? onTap;
  Color? color;
  bool? download;
  Widget? suffix;
  bool? noIcon;
  bool? padding;
  int? count;

  ProfileMenu({Key? key, required this.title, this.padding = true, this.suffix, required this.icon, this.onTap, this.download = false, this.count, this.color, this.noIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.formFieldBorderColor, width: 1),
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
        padding: padding! ? const EdgeInsets.symmetric(vertical: 12, horizontal: 15) : const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(icon, color: color ?? Colors.black87, size: 16,),
                  const SizedBox(width: 20,),
                  Flexible(child: Text(title.toString(), style: const TextStyle(color: Colors.black87, fontSize: 14),),),
                  noIcon != null && noIcon! == true ? Container(): download! ? const Icon(Icons.download_outlined, color: Colors.black45,)
                    : (count == null ? const Icon(Icons.chevron_right_outlined, color: Colors.black45,)
                    : Text(count.toString())),
                ],
              ),
            ),
            if (suffix != null)
              suffix!
          ],
        ),
      ),
    );
  }
}