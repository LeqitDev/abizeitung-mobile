import 'package:abizeitung_mobile/api/api.dart';
import 'package:abizeitung_mobile/assets/assets.dart';
import 'package:abizeitung_mobile/assets/widgets/custom_rounded_elevated_button.dart';
import 'package:abizeitung_mobile/assets/widgets/form_widgets.dart';
import 'package:abizeitung_mobile/stores/app/app_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _LoginData {
  String username = '';
  String password = '';
  bool savePrefs = false;
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _LoginData _data = _LoginData();

  @override
  Widget build(BuildContext context) {
    final appStore = context.read<AppStore>();

    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Transform.translate(
            offset:
                Offset(MediaQuery.of(context).size.width - (218 / 3) * 2, -70),
            child: Container(
              width: 218,
              height: 218,
              decoration: const BoxDecoration(
                color: secondaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(MediaQuery.of(context).size.width / 2 + 20.0, -25),
            child: Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: Color(0xFF340068),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2.0, color: Colors.black)),
                padding: const EdgeInsets.all(5.0),
                margin: const EdgeInsets.all(15.0),
                child: const Icon(
                  Icons.school,
                  size: 35.0,
                ),
              ),
              const Spacer(),
              SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0)),
                      color: secondaryColor,
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 0.0,
                            blurRadius: 4.0,
                            color: Color(0x44000000),
                            offset: Offset(0, -4)),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 15.0),
                    child: Column(
                      children: [
                        const Text(
                          "Abizeitung\nOnline",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 32),
                          textAlign: TextAlign.center,
                        ),
                        const Padding(padding: EdgeInsets.all(10.0)),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                label: 'Benutzername',
                                validator: (value) {
                                  if (value == null) {
                                    return 'Du musst einen Benutzernamen angeben!';
                                  }
                                  return null;
                                },
                                onSave: (value) {
                                  _data.username = value!;
                                },
                              ),
                              const Padding(padding: EdgeInsets.only(top: 5.0)),
                              CustomTextField(
                                label: 'Passwort',
                                validator: (value) {
                                  if (value == null) {
                                    return 'Du musst ein Passwort angeben!';
                                  }
                                  return null;
                                },
                                password: true,
                                onSave: (value) {
                                  _data.password = value!;
                                },
                              ),
                              const Padding(padding: EdgeInsets.only(top: 5.0)),
                              CustomCheckbox(
                                label: "Angemeldet bleiben",
                                onChanged: (value) {
                                  _data.savePrefs = value!;
                                },
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(top: 10.0)),
                              CustomRoundedElevatedButton(
                                label: 'Login',
                                onButtonPressed: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  if (!_formKey.currentState!.validate())
                                    return;
                                  _formKey.currentState!.save();

                                  final loggedin = await appStore.api
                                      .authenticateWithUsernameAndPassword(
                                    appStore,
                                    _data.username,
                                    _data.password,
                                    storeCredentials: _data.savePrefs,
                                  );

                                  bool isLoggedIn =
                                      loggedin.state == ReturnState.successful;

                                  if (isLoggedIn) {
                                    appStore.changeAuthenticationState(
                                        AuthenticationState.authenticated);
                                    appStore.loadAll(appStore);
                                    //Navigator.pushReplacementNamed(context, '/app');
                                  } else {
                                    appStore.changeAuthenticationState(
                                        AuthenticationState.unauthenticated);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Something went wrong! Please try again! Error Code: ${loggedin.code}')));
                                  }
                                },
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  size: 32.0,
                                ),
                                side: Side.right,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
