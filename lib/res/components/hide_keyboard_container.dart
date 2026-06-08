import 'package:flutter/cupertino.dart';

class HideKeyBordContainer extends StatelessWidget {
  final Widget child;
  const HideKeyBordContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }

}