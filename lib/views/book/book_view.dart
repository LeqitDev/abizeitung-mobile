import 'package:abizeitung_mobile/assets/assets.dart';
import 'package:abizeitung_mobile/views/profiles/profiles_view.dart';
import 'package:flutter/material.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const BookPage());
  }

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getScreenWidth(context),
      height: getScreenHeight(context),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: bigButton(
                  () => Navigator.push(context, ProfilesPage.route()),
                  'Profile',
                  Icons.person,
                  first: true,
                  iconSize: 50)),
          Expanded(
              child: bigButton(() => null, 'Sprüche', Icons.chat_bubble,
                  last: true, iconSize: 40)),
        ],
      ),
    );
  }

  Widget bigButton(Function() onPressed, String label, IconData icon,
      {bool? last, bool? first, double? iconSize}) {
    double normalPadding = 30.0;
    EdgeInsetsGeometry padding = EdgeInsets.symmetric(
        horizontal: normalPadding, vertical: normalPadding / 2);
    if (first ?? false) {
      padding = EdgeInsets.fromLTRB(
          normalPadding, normalPadding, normalPadding, normalPadding / 2);
    } else if (last ?? false) {
      padding = EdgeInsets.fromLTRB(
          normalPadding, normalPadding / 2, normalPadding, normalPadding);
    }
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: primaryColor,
              boxShadow: const [
                defaultBoxShadow,
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: iconSize ?? 40,
              ),
              Text(
                label,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
