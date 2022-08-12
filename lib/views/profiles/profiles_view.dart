import 'package:abizeitung_mobile/assets/assets.dart';
import 'package:abizeitung_mobile/assets/widgets/custom_app_bar.dart';
import 'package:abizeitung_mobile/assets/widgets/custom_sliding_button.dart';
import 'package:abizeitung_mobile/models/user_model.dart';
import 'package:abizeitung_mobile/stores/app/app_store.dart';
import 'package:abizeitung_mobile/stores/profile/profile_store.dart';
import 'package:abizeitung_mobile/views/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ProfilesPage extends StatefulWidget {
  const ProfilesPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (context) => const ProfilesPage());
  }

  @override
  State<ProfilesPage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends State<ProfilesPage> {
  int _typeIndex = 0;
  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    final appStore = context.read<AppStore>();

    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: CustomAppBar(
        search: true,
        backButton: true,
        searchString: _searchString,
        onChanged: (value) {
          setState(() {
            _searchString = value;
          });
        },
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Padding(padding: EdgeInsets.only(bottom: 10.0)),
          CustomSlidingButton(
            text1: 'Schüler',
            text2: 'Lehrer',
            fn: (index) {
              setState(() {
                _typeIndex = index;
              });
            },
            height: 40.0,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10.0)),
          Expanded(
            child: Observer(
              builder: (context) {
                if (appStore.haveStudents && appStore.haveTeachers) {
                  if (_typeIndex == 0) {
                    return ListView.builder(
                      itemCount: appStore.students.length,
                      itemBuilder: (context, index) {
                        final student = appStore.students[index];
                        if (student.getName
                            .toLowerCase()
                            .contains(_searchString.toLowerCase())) {
                          return getUserCard(student, appStore);
                        } else {
                          return Container();
                        }
                      },
                    );
                  } else {
                    return ListView.builder(
                      itemCount: appStore.teachers.length,
                      itemBuilder: (context, index) {
                        final teacher = appStore.teachers[index];
                        if (teacher.getName
                            .toLowerCase()
                            .contains(_searchString.toLowerCase())) {
                          return getUserCard(teacher, appStore);
                        } else {
                          return Container();
                        }
                      },
                    );
                  }
                } else {
                  appStore.loadStudentsAndTeachers(appStore);
                  return const CircularProgressIndicator(
                    color: primaryColor,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  getUserCard(BasicUser user, AppStore appStore) {
    return Card(
      color: primaryColor,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Provider(
                create: (_) => ProfileStore()
                  ..init(user.getID, _typeIndex == 0 ? 'student' : 'teacher',
                      user.getName, appStore),
                child: const ProfilePage(),
              ),
            ),
          );
        },
        child: ListTileTheme(
          contentPadding: const EdgeInsets.only(left: 14.0),
          child: ListTile(
            leading: Container(
              width: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    colors: _typeIndex == 0
                        ? [
                            lighterSecondaryColor,
                            lighterSecondaryColor,
                            accentColor,
                            accentColor,
                          ]
                        : [
                            accentColor,
                            accentColor,
                            lighterSecondaryColor,
                            lighterSecondaryColor,
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 0.49, 0.51, 1.0]),
              ),
            ),
            title: Text(
              user.getName,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
        ),
      ),
    );
  }
}
