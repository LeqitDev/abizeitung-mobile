import 'package:flutter/material.dart';

import '../assets.dart';

class CustomRoundedElevatedButton extends StatelessWidget {
  final String label;
  final Function() onButtonPressed;
  final Icon? icon;
  final Side? side;

  const CustomRoundedElevatedButton(
      {Key? key,
      required this.label,
      required this.onButtonPressed,
      this.icon,
      this.side})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isWithIcon = icon != null;
    bool left = isWithIcon && (side == null || side == Side.left);
    bool right = isWithIcon && !left;

    List<Widget> children = [];

    if (left) {
      children = [
        icon!,
        const Padding(padding: EdgeInsets.only(right: 5.0)),
        Text(label),
      ];
    } else if (right) {
      children = [
        Text(label),
        const Padding(padding: EdgeInsets.only(left: 5.0)),
        icon!,
      ];
    } else {
      children = [
        Text(label),
      ];
    }

    return ElevatedButton(
      onPressed: onButtonPressed,
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
        textStyle: const TextStyle(fontSize: 22.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
