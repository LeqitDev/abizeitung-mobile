import 'package:abizeitung_mobile/models/comment_model.dart';
import 'package:abizeitung_mobile/stores/app/app_store.dart';
import 'package:mobx/mobx.dart';

part 'profile_store.g.dart';

class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  int? _userId;
  String? _type;
  String? _name;
  List<Comment>? _comments;

  @computed
  int get getUserId => _userId!;

  @computed
  String get getType => _type!;

  @computed
  String get getName => _name!;

  @computed
  List<Comment> get getComments => _comments!;

  @observable
  bool haveComments = false;

  @action
  Future fetchComments(AppStore appStore) async {
    final comments = await Comment()
        .getComments(appStore, userid: _userId, userGroup: _type);
    if (comments.length > 1 && _comments == null) {
      _comments = comments;
      haveComments = true;
    } else if (comments.length > 1 && _comments != null) {
      if (comments.length != _comments!.length) {
        haveComments = false;
        _comments = comments;
        Future.delayed(const Duration(milliseconds: 20), () {
          haveComments = true;
        });
        return;
      }
      final length = comments.length > _comments!.length
          ? comments.length
          : _comments!.length;
      for (int i = 0; i < length; i++) {
        if (comments[i].comment != _comments![i].comment) {
          haveComments = false;
          _comments = comments;
          Future.delayed(const Duration(milliseconds: 20), () {
            haveComments = true;
          });
          return;
        }
      }
    }
  }

  @action
  void init(int userId, String type, String name, AppStore appStore) {
    _userId = userId;
    _type = type;
    _name = name;
    fetchComments(appStore);
  }
}
