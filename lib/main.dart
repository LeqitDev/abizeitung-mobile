import 'package:abizeitung_mobile/stores/app/app_store.dart';
import 'package:abizeitung_mobile/views/home/home_view.dart';
import 'package:abizeitung_mobile/views/login/login_view.dart';
import 'package:abizeitung_mobile/views/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider<AppStore>(
        create: (_) => AppStore(),
      ),
    ],
    child: const Main(),
  ));
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Main();
}

class _Main extends State<Main> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  AppStore appStore = AppStore();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void dispose() {
    appStore.api.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appStore = context.read<AppStore>();

    return MaterialApp(
      title: "Abizeitung Online - Mobile",
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        final dispose = appStore.addReaction((_) => appStore.state, (newState) {
          switch (newState) {
            case AuthenticationState.unknown:
              _navigator.pushAndRemoveUntil(
                  SplashPage.route(), (route) => false);
              break;
            case AuthenticationState.unauthenticated:
              _navigator.pushAndRemoveUntil(
                  LoginPage.route(), (route) => false);
              break;
            case AuthenticationState.authenticated:
              _navigator.pushAndRemoveUntil(HomePage.route(), (route) => false);
              break;
          }
        });
        return child!;
      },
      onGenerateRoute: (_) => SplashPage.route(),
      routes: {},
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFFACFCD9),
            onPrimary: const Color(0xFF000000),
            padding: const EdgeInsets.all(7.0),
            minimumSize: const Size(15.0, 30.0),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFACFCD9),
            primary: const Color(0xFF000000),
          ),
        ),
      ),
    );
  }
}
