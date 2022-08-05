import 'package:flutter/cupertino.dart';

Size getTextSize(String text, TextStyle style) {
  final textSpan = TextSpan(
    text: text,
    style: style,
  );
  final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
  tp.layout();
  return tp.size;
}

const defaultBoxShadow = BoxShadow(
    spreadRadius: 0.0,
    blurRadius: 4.0,
    color: Color(0x44000000),
    offset: Offset(0, 4));
const primaryColor = Color(0xFFACFCD9);
const secondaryColor = Color(0xFF3B413C);
const lighterSecondaryColor = Color(0xFF68736A);

enum Side { left, right }

double getScreenWidth(BuildContext context, {double? percentage}) {
  double screenWidth = MediaQuery.of(context).size.width;
  return percentage != null ? percentage * screenWidth : screenWidth;
}

double getScreenHeight(BuildContext context, {double? percentage}) {
  double screenHeight = MediaQuery.of(context).size.height;
  return percentage != null ? percentage * screenHeight : screenHeight;
}
