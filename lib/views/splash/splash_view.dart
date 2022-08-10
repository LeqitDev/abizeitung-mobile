import 'package:abizeitung_mobile/api/api.dart';
import 'package:abizeitung_mobile/assets/assets.dart';
import 'package:abizeitung_mobile/assets/widgets/dialogs.dart';
import 'package:abizeitung_mobile/stores/app/app_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  }

  @override
  State<SplashPage> createState() => _SplashPage();
}

class _SplashPage extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Color?> _backgroundAnimation;

  @override
  void initState() {
    isAuthed();
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..addListener(() {
            setState(() {});
          })
          ..forward()
          ..repeat(reverse: true);
    _backgroundAnimation =
        ColorTween(begin: Colors.transparent, end: accentColor.withAlpha(25))
            .animate(CurvedAnimation(
                parent: _animationController, curve: Curves.easeInOut));
  }

  isAuthed() async {
    final appStore = context.read<AppStore>();
    final authed = await appStore.api.authenticate(appStore);

    if (authed.state == ReturnState.successful) {
      await appStore.loadAllAndWait(appStore);
      appStore.changeAuthenticationState(AuthenticationState.authenticated);
    } else if (authed.state == ReturnState.error) {
      if (!mounted) return;
      _animationController.stop();
      RetryConnectionDialog().launchDialog(context, () {
        _animationController.forward();
        isAuthed();
      }, authed.code);
    } else {
      appStore.changeAuthenticationState(AuthenticationState.unauthenticated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appStore = context.read<AppStore>();

    return Stack(
      children: [
        Container(
          width: getScreenWidth(context),
          height: getScreenHeight(context),
          color: primaryColor,
        ),
        Container(
          width: getScreenWidth(context),
          height: getScreenHeight(context),
          color: _backgroundAnimation.value,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2.0, color: Colors.black)),
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: const Icon(
                    Icons.school,
                    size: 50.0,
                  ),
                ),
                const Text(
                  "Abizeitung\nOnline",
                  style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );

    /* return FutureBuilder(
      future: appStore.api.tryAuthenticationFromStore(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          if (snapshot.data == true) {
            setState(() {
              appStore
                  .changeAuthenticationState(AuthenticationState.authenticated);
            });
            /* Future.microtask(
                () => Navigator.pushReplacementNamed(context, '/app')); */
          } else {
            appStore
                .changeAuthenticationState(AuthenticationState.unauthenticated);
            print("unauthed" + appStore.state.toString());
            //Navigator.pushReplacementNamed(context, '/login');
          }
          print("${appStore.state}");
          return Scaffold(
            body: const Center(child: CircularProgressIndicator()),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                appStore.changeAuthenticationState(
                    AuthenticationState.unauthenticated);
                Future.delayed(Duration(seconds: 1));
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
              tooltip: 'Add comment',
              child: const Icon(Icons.add),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      }),
    ); */
  }
}
