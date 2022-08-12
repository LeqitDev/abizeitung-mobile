// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileStore on _ProfileStore, Store {
  Computed<int>? _$getUserIdComputed;

  @override
  int get getUserId => (_$getUserIdComputed ??=
          Computed<int>(() => super.getUserId, name: '_ProfileStore.getUserId'))
      .value;
  Computed<String>? _$getTypeComputed;

  @override
  String get getType => (_$getTypeComputed ??=
          Computed<String>(() => super.getType, name: '_ProfileStore.getType'))
      .value;
  Computed<String>? _$getNameComputed;

  @override
  String get getName => (_$getNameComputed ??=
          Computed<String>(() => super.getName, name: '_ProfileStore.getName'))
      .value;
  Computed<List<Comment>>? _$getCommentsComputed;

  @override
  List<Comment> get getComments => (_$getCommentsComputed ??=
          Computed<List<Comment>>(() => super.getComments,
              name: '_ProfileStore.getComments'))
      .value;

  late final _$haveCommentsAtom =
      Atom(name: '_ProfileStore.haveComments', context: context);

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

  late final _$fetchCommentsAsyncAction =
      AsyncAction('_ProfileStore.fetchComments', context: context);

  @override
  Future<dynamic> fetchComments(AppStore appStore) {
    return _$fetchCommentsAsyncAction.run(() => super.fetchComments(appStore));
  }

  late final _$_ProfileStoreActionController =
      ActionController(name: '_ProfileStore', context: context);

  @override
  void init(int userId, String type, String name, AppStore appStore) {
    final _$actionInfo =
        _$_ProfileStoreActionController.startAction(name: '_ProfileStore.init');
    try {
      return super.init(userId, type, name, appStore);
    } finally {
      _$_ProfileStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
haveComments: ${haveComments},
getUserId: ${getUserId},
getType: ${getType},
getName: ${getName},
getComments: ${getComments}
    ''';
  }
}
