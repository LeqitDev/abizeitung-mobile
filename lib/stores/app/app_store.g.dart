// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStore, Store {
  Computed<API>? _$apiComputed;

  @override
  API get api =>
      (_$apiComputed ??= Computed<API>(() => super.api, name: '_AppStore.api'))
          .value;
  Computed<AppUser>? _$appUserComputed;

  @override
  AppUser get appUser => (_$appUserComputed ??=
          Computed<AppUser>(() => super.appUser, name: '_AppStore.appUser'))
      .value;
  Computed<List<User>>? _$studentsComputed;

  @override
  List<User> get students =>
      (_$studentsComputed ??= Computed<List<User>>(() => super.students,
              name: '_AppStore.students'))
          .value;
  Computed<List<Teacher>>? _$teachersComputed;

  @override
  List<Teacher> get teachers =>
      (_$teachersComputed ??= Computed<List<Teacher>>(() => super.teachers,
              name: '_AppStore.teachers'))
          .value;
  Computed<List<BasicUser>>? _$studentsAndTeachersComputed;

  @override
  List<BasicUser> get studentsAndTeachers => (_$studentsAndTeachersComputed ??=
          Computed<List<BasicUser>>(() => super.studentsAndTeachers,
              name: '_AppStore.studentsAndTeachers'))
      .value;

  late final _$stateAtom = Atom(name: '_AppStore.state', context: context);

  @override
  AuthenticationState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(AuthenticationState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$haveCommentsAtom =
      Atom(name: '_AppStore.haveComments', context: context);

  @override
  bool get haveComments {
    _$haveCommentsAtom.reportRead();
    return super.haveComments;
  }

  @override
  set haveComments(bool value) {
    _$haveCommentsAtom.reportWrite(value, super.haveComments, () {
      super.haveComments = value;
    });
  }

  late final _$haveStudentsAtom =
      Atom(name: '_AppStore.haveStudents', context: context);

  @override
  bool get haveStudents {
    _$haveStudentsAtom.reportRead();
    return super.haveStudents;
  }

  @override
  set haveStudents(bool value) {
    _$haveStudentsAtom.reportWrite(value, super.haveStudents, () {
      super.haveStudents = value;
    });
  }

  late final _$haveTeachersAtom =
      Atom(name: '_AppStore.haveTeachers', context: context);

  @override
  bool get haveTeachers {
    _$haveTeachersAtom.reportRead();
    return super.haveTeachers;
  }

  @override
  set haveTeachers(bool value) {
    _$haveTeachersAtom.reportWrite(value, super.haveTeachers, () {
      super.haveTeachers = value;
    });
  }

  late final _$havePhrasesAtom =
      Atom(name: '_AppStore.havePhrases', context: context);

  @override
  bool get havePhrases {
    _$havePhrasesAtom.reportRead();
    return super.havePhrases;
  }

  @override
  set havePhrases(bool value) {
    _$havePhrasesAtom.reportWrite(value, super.havePhrases, () {
      super.havePhrases = value;
    });
  }

  late final _$loadStudentsAsyncAction =
      AsyncAction('_AppStore.loadStudents', context: context);

  @override
  Future<dynamic> loadStudents(AppStore appStore) {
    return _$loadStudentsAsyncAction.run(() => super.loadStudents(appStore));
  }

  late final _$loadTeachersAsyncAction =
      AsyncAction('_AppStore.loadTeachers', context: context);

  @override
  Future<dynamic> loadTeachers(AppStore appStore) {
    return _$loadTeachersAsyncAction.run(() => super.loadTeachers(appStore));
  }

  late final _$loadStudentsAndTeachersAsyncAction =
      AsyncAction('_AppStore.loadStudentsAndTeachers', context: context);

  @override
  Future<dynamic> loadStudentsAndTeachers(AppStore appStore) {
    return _$loadStudentsAndTeachersAsyncAction
        .run(() => super.loadStudentsAndTeachers(appStore));
  }

  late final _$getStudentsASAsyncAction =
      AsyncAction('_AppStore.getStudentsAS', context: context);

  @override
  Future<List<User>> getStudentsAS(AppStore appStore) {
    return _$getStudentsASAsyncAction.run(() => super.getStudentsAS(appStore));
  }

  late final _$getTeachersASAsyncAction =
      AsyncAction('_AppStore.getTeachersAS', context: context);

  @override
  Future<List<Teacher>> getTeachersAS(AppStore appStore) {
    return _$getTeachersASAsyncAction.run(() => super.getTeachersAS(appStore));
  }

  late final _$getBothUserTypesAsyncAction =
      AsyncAction('_AppStore.getBothUserTypes', context: context);

  @override
  Future<List<BasicUser>> getBothUserTypes(AppStore appStore) {
    return _$getBothUserTypesAsyncAction
        .run(() => super.getBothUserTypes(appStore));
  }

  late final _$_AppStoreActionController =
      ActionController(name: '_AppStore', context: context);

  @override
  void loadAll(AppStore appStore) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.loadAll');
    try {
      return super.loadAll(appStore);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  User? getStudentFromId(int id, AppStore appStore) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.getStudentFromId');
    try {
      return super.getStudentFromId(id, appStore);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Teacher? getTeacherFromId(int id, AppStore appStore) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.getTeacherFromId');
    try {
      return super.getTeacherFromId(id, appStore);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeAuthenticationState(AuthenticationState newState) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.changeAuthenticationState');
    try {
      return super.changeAuthenticationState(newState);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state},
haveComments: ${haveComments},
haveStudents: ${haveStudents},
haveTeachers: ${haveTeachers},
havePhrases: ${havePhrases},
api: ${api},
appUser: ${appUser},
students: ${students},
teachers: ${teachers},
studentsAndTeachers: ${studentsAndTeachers}
    ''';
  }
}
