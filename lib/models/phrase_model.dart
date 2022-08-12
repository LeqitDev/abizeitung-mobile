import 'dart:convert';

import 'package:abizeitung_mobile/api/api.dart';
import 'package:abizeitung_mobile/stores/app/app_store.dart';

class Phrase {
  int? id;
  int? authorid;
  String? course;
  String? phrase;

  int get getID {
    return id!;
  }

  int get getAuthorID {
    return authorid!;
  }

  String get getPhrase {
    return phrase!;
  }

  String get getCourse {
    return course!;
  }

  Phrase();

  factory Phrase.json(Map<String, dynamic> json) {
    final phrase = Phrase();
    phrase.id = json['id'];
    phrase.authorid = json['authorid'];
    phrase.course = json['course'];
    phrase.phrase = json['phrase'];
    return phrase;
  }

  Map<String, dynamic> toJSON(bool withID,
      {int? id,
      int? authorid,
      String? course,
      String? phrase,
      Phrase? phraseObj}) {
    Map<String, dynamic> json;
    if (phraseObj == null) {
      if ((id != null || !withID) &&
          authorid != null &&
          course != null &&
          phrase != null) {
        json = {
          if (withID) 'id': id,
          'authorid': authorid,
          'course': course,
          'phrase': phrase,
        };
        return json;
      } else {
        return {};
      }
    } else {
      json = {
        if (withID) 'id': phraseObj.getID,
        'authorid': phraseObj.getAuthorID,
        'course': phraseObj.getCourse,
        'phrase': phraseObj.getPhrase,
      };
      return json;
    }
  }

  Future<List<Phrase>> getPhrases(AppStore appStore, {int? page}) async {
    int realPage = page ?? 1;
    String args = "?page=$realPage";

    final res = await appStore.api.request('get', 'phrases$args');
    if (res.state != ReturnState.successful) return [];
    final jsonRes = jsonDecode(res.response!.body);

    List<Phrase> list = [];
    for (var phrase in (jsonRes['hydra:member'] as List<dynamic>)) {
      list.add(Phrase.json(phrase));
    }

    if (jsonRes['hydra:view']['hydra:next'] != null) {
      realPage++;
      list.addAll(await getPhrases(appStore, page: realPage));
    }

    return list;
  }

  Future<bool> add(
      AppStore appStore, int appUserId, String course, String phrase) async {
    final res = await appStore.api.request('post', 'phrases',
        body:
            toJSON(false, authorid: appUserId, course: course, phrase: phrase));
    if (res.response?.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> delete(AppStore appStore, {int? phraseID}) async {
    final res =
        await appStore.api.request('delete', 'phrases/${phraseID ?? id}');
    if (res.response?.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}
