import 'package:abizeitung_mobile/assets/assets.dart';
import 'package:abizeitung_mobile/assets/widgets/custom_app_bar.dart';
import 'package:abizeitung_mobile/assets/widgets/custom_bottom_navigation_bar.dart';
import 'package:abizeitung_mobile/stores/app/app_store.dart';
import 'package:abizeitung_mobile/views/book/book_view.dart';
import 'package:abizeitung_mobile/views/comment/comment_view.dart';
import 'package:abizeitung_mobile/views/comment/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final double _appBarHeightOffset = 134.0;
  String name = "";
  int _pageIndex = 0;

  late final List<CustomPage> _pages;

  @override
  void initState() {
    super.initState();
    final appStore = context.read<AppStore>();

    _pages = <CustomPage>[
      CustomPage(
        content: Column(
          mainAxisSize: MainAxisSize.max,
          children: const [
            SizedBox(
              height: 70.0,
            ),
            Expanded(
              child: CommentPage(),
            ),
          ],
        ),
        designWidgets: [
          Transform.translate(
            offset: const Offset(-50.0, -80.0),
            child: Container(
              width: 270.0,
              height: 270.0,
              decoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    defaultBoxShadow,
                  ]),
            ),
          ),
          Transform.translate(
            offset: const Offset(15.0, 35.0),
            child: const Text(
              "Moin",
              style: TextStyle(
                color: secondaryColor,
                fontSize: 36,
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(48.0, 82.0),
            child: Text(
              "${appStore.appUser.getFirstName}!", //TODO: Longer names go over...
              style: const TextStyle(
                color: Colors.black,
                fontSize: 36,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        appBar: CustomAppBar(
          search: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, SettingsPage.route());
              },
              icon: const Icon(
                Icons.settings,
                color: primaryColor,
                size: 34.0,
              ),
            ),
          ],
        ),
      ),
      CustomPage(content: const BookPage()),
      CustomPage(content: Container()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final appStore = context.read<AppStore>();

    void _onNaviagtionTapped(int index) {
      setState(() {
        _pageIndex = index;
      });
    }

    return Material(
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: secondaryColor,
          ),
          Scaffold(
            backgroundColor: const Color(0x00000000),
            appBar: _pages[_pageIndex].appBar,
            body: _pages[_pageIndex].content,
            bottomNavigationBar: CustomBottomNavigationBar(
                navigationTapped: (value) {
                  _onNaviagtionTapped(value);
                },
                currentIndex: _pageIndex),
          ),
          ..._pages[_pageIndex].designWidgets ?? [],
        ],
      ),
    );
  }
}

class CustomPage {
  CustomPage({this.designWidgets, this.appBar, required this.content});

  List<Widget>? designWidgets = <Widget>[];
  PreferredSizeWidget? appBar = AppBar(
    backgroundColor: const Color(0x00000000),
    elevation: 0,
  );
  Widget content;
}
