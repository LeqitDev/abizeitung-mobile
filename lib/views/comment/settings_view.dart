import 'package:abizeitung_mobile/assets/assets.dart';
import 'package:abizeitung_mobile/assets/widgets/custom_rounded_elevated_button.dart';
import 'package:abizeitung_mobile/assets/widgets/form_widgets.dart';
import 'package:abizeitung_mobile/stores/app/app_store.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SettingsPage());
  }

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _ChangePasswordData _changePwData = _ChangePasswordData();
  final _ProfileData _profileData = _ProfileData();
  final List<bool> _changedPw = [false, false, false];
  final List<bool> _changedData = [false, false];
  late final String _name;
  late final String _lk;

  final GlobalKey<FormState> _changePwKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _changeDataKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final appStore = context.read<AppStore>();
    _name = appStore.appUser.getName;
    _lk = appStore.appUser.getLK;
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<AppStore>(context);

    return Scaffold(
      backgroundColor: secondaryColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: primaryColor,
          size: 34,
        ),
      ),
      body: /* SizedBox(
        width: getScreenWidth(context),
        height: getScreenHeight(context),
        child:  */
          Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          /* SingleChildScrollView(
              child:  */
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Einstellungen',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Form(
                    key: _changePwKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Passwort ändern',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        CustomTextField(
                          label: 'Altes Passwort',
                          validator: (value) {
                            if (value == null) {
                              return 'Du musst ein Passwort angeben!';
                            }
                            return null;
                          },
                          password: true,
                          onSave: (value) {
                            _changePwData.oldpw = value!;
                          },
                          onChanged: (value) {
                            if (value != "") {
                              if (!_changedPw[0]) {
                                setState(() {
                                  _changedPw[0] = true;
                                });
                              }
                            } else {
                              if (_changedPw[0]) {
                                setState(() {
                                  _changedPw[0] = false;
                                });
                              }
                            }
                          },
                        ),
                        CustomTextField(
                          label: 'Neues Passwort',
                          validator: (value) {
                            if (value == null) {
                              return 'Du musst ein Passwort angeben!';
                            }
                            return null;
                          },
                          password: true,
                          onSave: (value) {
                            _changePwData.newpw = value!;
                          },
                          onChanged: (value) {
                            if (value != "") {
                              if (!_changedPw[1]) {
                                setState(() {
                                  _changedPw[1] = true;
                                });
                              }
                            } else {
                              if (_changedPw[1]) {
                                setState(() {
                                  _changedPw[1] = false;
                                });
                              }
                            }
                          },
                        ),
                        CustomTextField(
                          label: 'Passwort wiedeholen',
                          validator: (value) {
                            if (value == null) {
                              return 'Du musst ein Passwort angeben!';
                            }
                            return null;
                          },
                          password: true,
                          onSave: (value) {
                            _changePwData.pwrp = value!;
                          },
                          onChanged: (value) {
                            if (value != "") {
                              if (!_changedPw[2]) {
                                setState(() {
                                  _changedPw[2] = true;
                                });
                              }
                            } else {
                              if (_changedPw[2]) {
                                setState(() {
                                  _changedPw[2] = false;
                                });
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Form(
                    key: _changeDataKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Profil bearbeiten',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        CustomTextField(
                          label: 'Name',
                          value: _name,
                          validator: (value) {
                            if (value == null) {
                              return 'Du musst ein Passwort angeben!';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value != _name) {
                              if (!_changedData[0]) {
                                setState(() {
                                  _changedData[0] = true;
                                });
                              }
                            } else {
                              if (_changedData[0]) {
                                setState(() {
                                  _changedData[0] = false;
                                });
                              }
                            }
                          },
                          onSave: (value) {
                            _profileData.name = value!;
                          },
                        ),
                        CustomTextField(
                          label: 'Leistungskurse',
                          value: _lk,
                          validator: (value) {
                            if (value == null) {
                              return 'Du musst ein Passwort angeben!';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value! != _lk) {
                              if (!_changedData[1]) {
                                setState(() {
                                  _changedData[1] = true;
                                });
                              }
                            } else {
                              if (_changedData[1]) {
                                setState(() {
                                  _changedData[1] = false;
                                });
                              }
                            }
                          },
                          onSave: (value) {
                            _profileData.lks = value!;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed: () {
                appStore.api.logout();
                appStore.changeAuthenticationState(
                    AuthenticationState.unauthenticated);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 50.0),
                textStyle: const TextStyle(fontSize: 22.0),
                primary: const Color(0xFFB02E0C),
                onPrimary: const Color(0xFFFFFFFF),
              ),
              child: const Text("Logout"),
            ),
          ),
        ],
      ),
      // ),
      floatingActionButton: (isBoolListTrue(_changedData, boolListFlagOne) ||
              isBoolListTrue(_changedPw, boolListFlagAll))
          ? Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () {
                  if (isBoolListTrue(_changedData, boolListFlagAll)) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (!_changeDataKey.currentState!.validate()) {
                      return;
                    }
                    _changeDataKey.currentState!.save();

                    appStore.api.request(
                      'patch',
                      'users/${appStore.appUser.id}',
                      body: appStore.appUser.toJson(
                          name: _profileData.name, lk: _profileData.lks),
                    );
                  } else {
                    if (_changedData[0]) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (!_changeDataKey.currentState!.validate()) {
                        return;
                      }
                      _changeDataKey.currentState!.save();

                      appStore.api.request(
                        'patch',
                        'users/${appStore.appUser.id}',
                        body: appStore.appUser.toJson(name: _profileData.name),
                      );
                    }
                    if (_changedData[1]) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (!_changeDataKey.currentState!.validate()) {
                        return;
                      }
                      _changeDataKey.currentState!.save();

                      appStore.api.request(
                        'patch',
                        'users/${appStore.appUser.id}',
                        body: appStore.appUser.toJson(lk: _profileData.lks),
                      );
                    }
                  }

                  if (isBoolListTrue(_changedPw, boolListFlagAll)) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (!_changePwKey.currentState!.validate()) {
                      return;
                    }
                    _changePwKey.currentState!.save();

                    if (_changePwData.newpw == _changePwData.pwrp) {
                      if (BCrypt.checkpw(
                          _changePwData.oldpw, appStore.appUser.password!)) {
                        appStore.api.request(
                          'patch',
                          'users/${appStore.appUser.id}',
                          body: appStore.appUser.toJson(
                              password: BCrypt.hashpw(
                                  _changePwData.newpw, BCrypt.gensalt())),
                        );
                        appStore.api.logout();
                        appStore.changeAuthenticationState(
                            AuthenticationState.unauthenticated);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Das alte Passwort stimmt nicht!')));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'Das neue Passwort stimmt nicht mit dem wiederholten Passwort überein!')));
                    }
                  }
                },
                child: const Icon(
                  Icons.save,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            )
          : null,
    );
  }
}

class _ChangePasswordData {
  String oldpw = "";
  String newpw = "";
  String pwrp = "";
}

class _ProfileData {
  String name = "";
  String lks = "";
}
