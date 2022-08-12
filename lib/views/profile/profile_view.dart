import 'package:abizeitung_mobile/assets/assets.dart';
import 'package:abizeitung_mobile/assets/widgets/form_widgets.dart';
import 'package:abizeitung_mobile/models/comment_model.dart';
import 'package:abizeitung_mobile/stores/app/app_store.dart';
import 'package:abizeitung_mobile/stores/profile/profile_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();
  bool _showNewComment = false;
  String _newComment = "";
  final GlobalKey<FormState> _newCommentFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _editCommentFormKey = GlobalKey<FormState>();
  Map<int, bool> editComment = {};

  @override
  Widget build(BuildContext context) {
    final profileStore = context.read<ProfileStore>();
    final appStore = context.read<AppStore>();
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: primaryColor,
            size: 34.0,
          )),
      body: Stack(
        children: [
          Transform.translate(
            offset: Offset(getScreenWidth(context) - 85, -(85.0 + 50.0)),
            child: Container(
              width: 170,
              height: 170,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: accentColor),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
                child: Text(
                  profileStore.getName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
              Observer(
                builder: (context) {
                  if (profileStore.haveComments) {
                    final comments = [
                      ...profileStore.getComments,
                      Comment()..id = -1
                    ];

                    return Expanded(
                      child: ShaderMask(
                        shaderCallback: (Rect rect) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: const [
                              secondaryColor,
                              Color.fromARGB(0, 0, 0, 0),
                            ],
                            stops: [
                              0.0,
                              0.2 *
                                  (_scrollController.offset / 30)
                                      .clamp(0, 1), // fading top if scolling
                            ],
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstOut,
                        child: ScrollConfiguration(
                          behavior: const ScrollBehavior(),
                          child: GlowingOverscrollIndicator(
                            axisDirection: AxisDirection.down,
                            color: secondaryColor,
                            child: ListView.builder(
                              controller: _scrollController,
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 60.0),
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                final comment = comments[index];
                                if (comment.getID == -1 && !_showNewComment) {
                                  return Container();
                                }
                                if (comment.getID == -1 && _showNewComment) {
                                  return Card(
                                    color: lighterSecondaryColor,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6.0),
                                    child: ListTileTheme(
                                      textColor: Colors.white,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, right: 14.0),
                                      child: ListTile(
                                        title: Form(
                                          key: _newCommentFormKey,
                                          child: commentTextField("",
                                              (value) async {
                                            if (!_newCommentFormKey
                                                .currentState!
                                                .validate()) return;
                                            _newCommentFormKey.currentState!
                                                .save();
                                            Comment().add(
                                                appStore,
                                                profileStore.getUserId,
                                                appStore.appUser.getID,
                                                _newComment,
                                                profileStore.getType);
                                            setState(() {
                                              _showNewComment = false;
                                              profileStore
                                                  .fetchComments(appStore);
                                            });
                                          }, () {
                                            setState(() {
                                              _showNewComment = false;
                                            });
                                          }),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (editComment.containsKey(comment.getID) &&
                                    editComment[comment.getID] == true) {
                                  return Card(
                                    color: lighterSecondaryColor,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6.0),
                                    child: ListTileTheme(
                                      textColor: Colors.white,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0, right: 14.0),
                                      child: ListTile(
                                        title: Form(
                                          key: _editCommentFormKey,
                                          child: commentTextField(
                                              comment.getComment,
                                              (value) async {
                                            if (!_editCommentFormKey
                                                .currentState!
                                                .validate()) return;
                                            _editCommentFormKey.currentState!
                                                .save();
                                            comment.edit(appStore, _newComment);
                                            setState(() {
                                              _showNewComment = false;
                                              profileStore
                                                  .fetchComments(appStore);
                                              editComment[comment.getID] =
                                                  false;
                                            });
                                          }, () {
                                            setState(() {
                                              editComment[comment.getID] =
                                                  false;
                                            });
                                          }),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Card(
                                  color: lighterSecondaryColor,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 6.0),
                                  child: ListTileTheme(
                                    textColor: Colors.white,
                                    contentPadding:
                                        const EdgeInsets.only(left: 14.0),
                                    child: ListTile(
                                      title: Text(comment.getComment),
                                      trailing: trailing(
                                          comment, appStore, profileStore),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButton:
          ((profileStore.getUserId != appStore.appUser.getID ||
                      profileStore.getType == 'teacher') &&
                  !_showNewComment)
              ? FloatingActionButton(
                  onPressed: () {
                    _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut);
                    setState(() {
                      _showNewComment = true;
                    });
                  },
                  tooltip: 'Add comment',
                  backgroundColor: primaryColor,
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 28,
                  ),
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  trailing(Comment comment, AppStore appStore, ProfileStore profileStore) {
    return (comment.authorid == appStore.appUser.getID ||
            appStore.appUser.getRoles.contains("ROLE_ADMIN"))
        ? PopupMenuButton(
            color: lighterSecondaryColor,
            icon: Icon(
              Icons.more_vert,
              color: primaryColor.withAlpha(200),
              size: 28,
            ),
            elevation: 20.0,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.edit,
                        color: primaryColor,
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                      Text(
                        "Bearbeiten",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                if (appStore.appUser.getRoles.contains("ROLE_ADMIN"))
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.info,
                          color: primaryColor,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0)),
                        Text(
                          "Details",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                      Text(
                        "Löschen",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ];
            },
            onSelected: (value) {
              switch (value) {
                case 1:
                  editComment[comment.getID] = true;
                  setState(() {
                    profileStore.fetchComments(appStore);
                  });
                  break;
                case 2:
                  /* CommentDetailDialog()
                      .launchDialog(context, appStore, comment); */
                  break;
                case 3:
                  comment.delete(appStore);
                  profileStore.fetchComments(appStore);

                  break;
              }
            },
          )
        : null;
  }

  Widget commentTextField(String value, void Function(String)? onFieldSubmitted,
      void Function()? onCancelPressed) {
    return CustomTextField(
      label: '',
      value: value,
      validator: (value) {
        if (value == null) {
          return 'Du musst auch schon was schreiben!';
        }
        return null;
      },
      onSave: (value) {
        _newComment = value!;
      },
      onFieldSubmitted: onFieldSubmitted,
      autofocus: true,
      suffixIcon: IconButton(
        onPressed: onCancelPressed,
        icon: const Icon(
          Icons.cancel,
          color: primaryColor,
        ),
      ),
    );
  }
}
