import 'dart:convert';

import 'package:abizeitung_mobile/stores/app/app_store.dart';

enum UserType { teacher, student }

class BasicUser {
  int? id;
  String? name;
  UserType? type;

  int get getID {
    return id!;
  }

  String get getName {
    return name!;
  }

  String get getFirstName {
    return name!.split(' ')[0];
  }

  String get getLastName {
    return name!.split(' ')[1];
  }

  UserType get getType {
    return type!;
  }

  BasicUser({this.id, this.name});

  Future<List<BasicUser>> getAllUsers(AppStore appStore) async {
    List<BasicUser> list = [];
    final users = await getUsers(appStore);
    final teachers = await getTeachers(appStore);
    list.addAll(users);
    list.addAll(teachers);
    return list;
  }
}

class User extends BasicUser {
  String? username;
  String? email;
  List<dynamic>? roles;
  String? lk;

  String get getUsername {
    return username!;
  }

  String get getEmail {
    return email!;
  }

  List<dynamic> get getRoles {
    return roles!;
  }

  String get getLK {
    return lk!;
  }

  User({this.username, this.email, this.roles, this.lk});

  factory User.json(Map<String, dynamic> json) {
    final user = User();
    user.id = json['id'];
    user.name = json['name'];
    user.email = json['email'];
    user.username = json['username'];
    user.roles = json['roles'];
    user.lk = json['lk'];
    user.type = UserType.student;
    return user;
  }
}

class Teacher extends BasicUser {
  Teacher();

  factory Teacher.json(Map<String, dynamic> json) {
    final teacher = Teacher();
    teacher.id = json['id'];
    teacher.name = json['name'];
    teacher.type = UserType.teacher;
    return teacher;
  }
}

class AppUser extends User {
  AppUser() : super();

  factory AppUser.json(Map<String, dynamic> json) {
    final user = AppUser();
    user.id = json['id'];
    user.name = json['name'];
    user.email = json['email'];
    user.username = json['username'];
    user.roles = json['roles'];
    user.lk = json['lk'];
    user.type = UserType.student;
    return user;
  }
}

Future<Teacher> getTeacher(AppStore appStore, int id) async {
  final res = await appStore.api.request('get', 'teachers/$id');
  final jsonRes = jsonDecode(res.response!.body);
  final teacher = Teacher.json(jsonRes);
  return teacher;
}

Future<List<Teacher>> getTeachers(AppStore appStore, {int? page}) async {
  int realPage = page ?? 1;
  final res = await appStore.api.request('get', 'teachers?page=$realPage');
  final jsonRes = jsonDecode(res.response!.body);

  List<Teacher> list = [];
  for (var teacher in (jsonRes['hydra:member'] as List<dynamic>)) {
    list.add(Teacher.json(teacher));
  }

  if (jsonRes['hydra:view']['hydra:next'] != null) {
    realPage++;
    final nextPageTeachers = await getTeachers(appStore, page: realPage);
    list.addAll(nextPageTeachers);
  }
  return list;
}

Future<User> getUser(AppStore appStore, int id) async {
  final res = await appStore.api.request('get', 'users/$id');
  final jsonRes = jsonDecode(res.response!.body);
  final user = User.json(jsonRes);
  return user;
}

Future<List<User>> getUsers(AppStore appStore, {int? page}) async {
  int realPage = page ?? 1;
  final res = await appStore.api.request('get', "users?page=$realPage");
  final jsonRes = jsonDecode(res.response!.body);

  List<User> list = [];
  for (var user in (jsonRes['hydra:member'] as List<dynamic>)) {
    list.add(User.json(user));
  }

  if (jsonRes['hydra:view']['hydra:next'] != null) {
    realPage++;
    final nextPageUsers = await getUsers(appStore, page: realPage);
    list.addAll(nextPageUsers);
  }
  return list;
}
