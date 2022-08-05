import 'package:abizeitung_mobile/api/api.dart';
import 'package:abizeitung_mobile/models/user_model.dart';
import 'package:mobx/mobx.dart';

part 'app_store.g.dart';

enum AuthenticationState { unknown, unauthenticated, authenticated }

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  final API _api = API();
  AppUser _appUser = AppUser();

  List<User>? _students;
  List<Teacher>? _teachers;
  // List<Comment>? _comments;
  // List<Phrase>? _phrases;

  @observable
  AuthenticationState state = AuthenticationState.unknown;

  @observable
  bool haveComments = false;

  @observable
  bool haveStudents = false;

  @observable
  bool haveTeachers = false;

  @observable
  bool havePhrases = false;

  @computed
  API get api => _api;

  @computed
  AppUser get appUser => _appUser;

  void setAppUser(Map<String, dynamic> json) {
    _appUser = AppUser.json(json);
  }

  @action
  void loadAll(AppStore appStore) {
    // loadAppUsersComments(appStore);
    loadStudentsAndTeachers(appStore);
    // loadPhrases(appStore);
    /* Future.delayed(const Duration(seconds: 10), () {
      updateNewComments(_comments!, appStore);
    }); */
  }

  /* @action
  Future loadAppUsersComments(AppStore appStore) async {
    final _commentsDatabase = await Comment().getComments(appStore,
        userid: appStore.api.usr.getID, userGroup: "student");
    if (_commentsDatabase.length > 1 && _comments == null) {
      _comments = _commentsDatabase;
      haveComments = true;
    } else if (_commentsDatabase.length > 1 && _comments != null) {
      bool update = mergeCommentList(_commentsDatabase);
      if (update) {
        haveComments = false;
        Future.delayed(const Duration(milliseconds: 14), () {
          haveComments = true;
          /* comments.forEach((element) {
            print(element.isNew.toString() + " - " + element.getComment);
          });
          _commentsDatabase.forEach((element) {
            print(element.isNew.toString() + " - " + element.getComment);
          }); */
        });
      }
      return;
    }
  }

  bool mergeCommentList(List<Comment> newCommentsList) {
    bool update = false;
    if (newCommentsList.length > comments.length) {
      update = true;

      updateCommentList(newCommentsList);

      int dif = newCommentsList.length - comments.length;
      for (int i = 0; i < dif; i++) {
        _comments!.add(newCommentsList[i + comments.length]);
      }
    } else if (newCommentsList.length == comments.length) {
      update = updateCommentList(newCommentsList);
    } else {
      update = true;

      updateCommentList(newCommentsList);

      List<Comment> tmpCommentList = List.from(comments);

      tmpCommentList.removeWhere((element) {
        bool contains = false;
        for (var element2 in newCommentsList) {
          contains = element.getID == element2.getID;
        }
        return contains;
      });

      _comments!.removeWhere((element) {
        bool contains = false;
        for (var element2 in tmpCommentList) {
          contains = element.getID == element2.getID;
        }
        if (contains) print("deleted comment[${element.getID}]");
        return contains;
      });
    }
    return update;
  }

  bool updateCommentList(List<Comment> newCommentsList) {
    int length = newCommentsList.length < comments.length
        ? newCommentsList.length
        : comments.length;
    bool update = false;
    for (int i = 0; i < length; i++) {
      if (newCommentsList[i].getComment != comments[i].getComment &&
          newCommentsList[i].getID == comments[i].getID) {
        print(
            "edited comment[${newCommentsList[i].getID}]: ${_comments![i].getComment} >> ${newCommentsList[i].getComment}");
        _comments![i].comment = newCommentsList[i].comment;
        update = true;
      }
    }
    return update;
  }

  updateNewComments(List<Comment> comments, AppStore appStore) {
    for (var element in comments) {
      if (element.isNew) element.updateNew(appStore, element);
    }
  }

  @action
  Future updateAppUserComments(AppStore appStore) async {
    haveComments = false;
    await loadAppUsersComments(appStore);
    haveComments = true;
  }

  @computed
  List<Comment> get comments => _comments!; */

  @action
  Future loadStudents(AppStore appStore) async {
    _students = await getUsers(appStore);
    if (_students != null) haveStudents = true;
  }

  @computed
  List<User> get students => _students!;

  @action
  Future loadTeachers(AppStore appStore) async {
    _teachers = await getTeachers(appStore);
    if (_teachers != null) haveTeachers = true;
  }

  @computed
  List<Teacher> get teachers => _teachers!;

  @action
  Future loadStudentsAndTeachers(AppStore appStore) async {
    await loadStudents(appStore);
    await loadTeachers(appStore);
  }

  @computed
  List<BasicUser> get studentsAndTeachers {
    if (haveStudents && haveTeachers) {
      List<BasicUser> all = [];
      all.addAll(_students as List<BasicUser>);
      all.addAll(_teachers as List<BasicUser>);
      return all;
    } else {
      return [];
    }
  }

  /* Future loadPhrases(AppStore appStore) async {
    _phrases = await Phrase().getPhrases(appStore);
    if (_phrases != null) havePhrases = true;
  }

  @computed
  List<Phrase> get phrases => _phrases!; */

  @action
  Future<List<User>> getStudentsAS(AppStore appStore) async {
    if (_students != null) return _students!;
    loadStudents(appStore);
    return _students!;
  }

  @action
  Future<List<Teacher>> getTeachersAS(AppStore appStore) async {
    if (_teachers != null) return _teachers!;
    loadTeachers(appStore);
    return _teachers!;
  }

  @action
  Future<List<BasicUser>> getBothUserTypes(AppStore appStore) async {
    final List<BasicUser> list = [];
    final students = await getStudentsAS(appStore);
    final teachers = await getTeachersAS(appStore);
    list.addAll(students);
    list.addAll(teachers);
    return list;
  }

  @action
  User? getStudentFromId(int id, AppStore appStore) {
    User? user;
    for (var element in appStore.students) {
      if (element.getID == id) user = element;
    }
    return user;
  }

  @action
  Teacher? getTeacherFromId(int id, AppStore appStore) {
    Teacher? user;
    for (var element in appStore.teachers) {
      if (element.getID == id) user = element;
    }
    return user;
  }

  addAutorunReaction(dynamic Function(Reaction) fn) {
    return autorun(fn);
  }

  addReaction<T>(T Function(Reaction) fn, void Function(T) effect) {
    return reaction(fn, effect);
  }

  @action
  void changeAuthenticationState(AuthenticationState newState) {
    state = newState;
  }
}
