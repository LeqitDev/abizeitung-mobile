import 'dart:convert';

import 'package:abizeitung_mobile/api/api.dart';
import 'package:abizeitung_mobile/stores/app/app_store.dart';

class Comment {
  int? id;
  int? userid;
  int? authorid;
  bool? _new;
  String? comment;
  String? group;

  int get getID {
    return id!;
  }

  int get getUserID {
    return userid!;
  }

  int get getAuthorID {
    return authorid!;
  }

  bool get isNew {
    return _new!;
  }

  String get getComment {
    return comment!;
  }

  String get getUserGroup {
    return group!;
  }

  Comment();

  factory Comment.json(Map<String, dynamic> json) {
    final comment = Comment();
    comment.id = json['id'];
    comment.userid = json['userid'];
    comment.authorid = json['authorid'];
    comment._new = json['new'];
    comment.comment = json['comment'];
    comment.group = json['userGroup'];
    return comment;
  }

  Map<String, dynamic> toJSON(bool withID,
      {int? id,
      int? userid,
      int? authorid,
      bool? isNew,
      String? comment,
      String? userGroup,
      Comment? commentObj}) {
    Map<String, dynamic> json;
    if (commentObj == null) {
      if ((id != null || !withID) &&
          userid != null &&
          authorid != null &&
          isNew != null &&
          comment != null &&
          userGroup != null) {
        json = {
          if (withID) 'id': id,
          'userid': userid,
          'authorid': authorid,
          'new': isNew,
          'comment': comment,
          'userGroup': userGroup,
          'visible': true,
        };
        return json;
      } else {
        return {};
      }
    } else {
      json = {
        if (withID) 'id': commentObj.getID,
        'userid': commentObj.getUserID,
        'authorid': commentObj.getAuthorID,
        'new': commentObj.isNew,
        'comment': commentObj.getComment,
        'userGroup': commentObj.getUserGroup,
        'visible': true,
      };
      return json;
    }
  }

  Future<bool> updateNew(AppStore appStore) async {
    _new = false;
    final res = await appStore.api.request('patch', 'comments/$getID',
        body: toJSON(false, commentObj: this));
    if (res.response?.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> edit(AppStore appStore, String newComment) async {
    comment = newComment;
    final res = await appStore.api.request('patch', 'comments/$getID',
        body: toJSON(false, commentObj: this));
    if (res.response?.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> add(AppStore appStore, int userId, int appUserId, String comment,
      String userGroup) async {
    final res = await appStore.api.request('post', 'comments',
        body: toJSON(false,
            userid: userId,
            authorid: appUserId,
            comment: comment,
            userGroup: userGroup,
            isNew: true));
    if (res.response?.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> delete(AppStore appStore, {int? commentId}) async {
    final res =
        await appStore.api.request('delete', 'comments/${commentId ?? id}');
    if (res.response?.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Comment>> getComments(AppStore appStore,
      {int? userid,
      int? authorid,
      bool? isNew,
      String? userGroup,
      int? page}) async {
    bool haveArgs = userid != null ||
        authorid != null ||
        isNew != null ||
        userGroup != null ||
        page != null;
    int realPage = page ?? 1;
    String args = haveArgs
        ? "?${page != null ? 'page=$realPage&' : ''}${userid != null ? 'userid=$userid&' : ''}${authorid != null ? 'authorid=$authorid&' : ''}${isNew != null ? 'new=${isNew == true ? '1' : '0'}&' : ''}${userGroup != null ? 'userGroup=$userGroup&' : ''}"
        : "";
    final res = await appStore.api.request('get', 'comments$args');
    if (res.state != ReturnState.successful) print('comments$args');
    final jsonRes = jsonDecode(res.response!.body);

    if (jsonRes['hydra:member'] == null) return [];

    List<Comment> list = [];
    (jsonRes['hydra:member'] as List<dynamic>).forEach((comment) {
      list.add(Comment.json(comment));
    });

    if (jsonRes['hydra:view']['hydra:next'] != null) {
      realPage++;
      list.addAll(await getComments(appStore,
          userid: userid,
          authorid: authorid,
          isNew: isNew,
          userGroup: userGroup,
          page: realPage));
    }

    return list;
  }
}
