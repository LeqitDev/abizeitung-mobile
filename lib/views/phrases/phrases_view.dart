import 'package:abizeitung_mobile/assets/assets.dart';
import 'package:abizeitung_mobile/assets/widgets/custom_app_bar.dart';
import 'package:abizeitung_mobile/assets/widgets/form_widgets.dart';
import 'package:abizeitung_mobile/models/phrase_model.dart';
import 'package:abizeitung_mobile/stores/app/app_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class PhrasesPage extends StatefulWidget {
  const PhrasesPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (context) => const PhrasesPage());
  }

  @override
  State<PhrasesPage> createState() => _PhrasesPageState();
}

class _PhrasesPageState extends State<PhrasesPage> {
  final ScrollController _scrollController = ScrollController();
  String _searchString = "";
  bool _showNewPhrase = false;
  final PhraseData _newPhrase = PhraseData();
  final GlobalKey<FormState> _newPhraseFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _editPhraseFormKey = GlobalKey<FormState>();
  Map<int, bool> editPhrase = {};

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, bottom: 10.0, top: 10.0),
            child: Text(
              "Sprüche",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ),
          Observer(
            builder: (context) {
              if (appStore.havePhrases) {
                final phrases = [...appStore.phrases, Phrase()..id = -1];
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
                          padding: const EdgeInsets.only(bottom: 80.0),
                          itemCount: phrases.length,
                          itemBuilder: (context, index) {
                            final phrase = phrases[index];
                            if (phrase.id == -1 && !_showNewPhrase) {
                              return Container();
                            }
                            if (phrase.id == -1 && _showNewPhrase) {
                              return Card(
                                color: lighterSecondaryColor,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                child: ListTileTheme(
                                  textColor: Colors.white,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, right: 14.0),
                                  child: Form(
                                    key: _newPhraseFormKey,
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: phraseTextField((value) {
                                              _newPhrase.course = value!;
                                            }, label: 'Kurs/Klasse'),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _showNewPhrase = false;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                                color: primaryColor,
                                              ))
                                        ],
                                      ),
                                      subtitle: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: phraseTextField((value) {
                                          _newPhrase.phrase = value!;
                                        }, label: 'Spruch'),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            if (!phrase.getCourse
                                    .toLowerCase()
                                    .contains(_searchString.toLowerCase()) &&
                                !phrase.getPhrase
                                    .toLowerCase()
                                    .contains(_searchString.toLowerCase())) {
                              return Container();
                            }
                            return Card(
                              color: lighterSecondaryColor,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: ListTileTheme(
                                textColor: Colors.white,
                                contentPadding: EdgeInsets.only(
                                    left: 14.0,
                                    right: !(phrase.getAuthorID ==
                                                appStore.appUser.getID ||
                                            appStore.appUser.getRoles
                                                .contains("ROLE_ADMIN"))
                                        ? 14.0
                                        : 0,
                                    bottom: 5.0,
                                    top: 5.0),
                                child: ListTile(
                                  title: Text(
                                    phrase.getCourse,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 7.0),
                                    child: Text(phrase.getPhrase),
                                  ),
                                  trailing: trailing(phrase, appStore),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_showNewPhrase) {
            if (!_newPhraseFormKey.currentState!.validate()) return;
            _newPhraseFormKey.currentState!.save();
            Phrase().add(appStore, appStore.appUser.getID, _newPhrase.course,
                _newPhrase.phrase);
            appStore.loadPhrases(appStore);
            setState(() {
              _showNewPhrase = false;
            });
            return;
          }
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut);
          setState(() {
            _showNewPhrase = true;
          });
        },
        // tooltip: 'Add comment',
        backgroundColor: primaryColor,
        child: Icon(
          _showNewPhrase ? Icons.save : Icons.add,
          color: Colors.black,
          size: 28,
        ),
      ),
    );
  }

  trailing(Phrase phrase, AppStore appStore) {
    return (phrase.getAuthorID == appStore.appUser.getID ||
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
                  /* editComment[comment.getID] = true;
                  setState(() {
                    profileStore.fetchComments(appStore);
                  }); */
                  break;
                case 2:
                  /* CommentDetailDialog()
                      .launchDialog(context, appStore, comment); */
                  break;
                case 3:
                  phrase.delete(appStore);
                  appStore.loadPhrases(appStore);

                  break;
              }
            },
          )
        : null;
  }

  Widget phraseTextField(Function(String?) onSave,
      {String? value, String? label}) {
    return CustomTextField(
      label: label ?? '',
      value: value ?? '',
      validator: (value) {
        if (value == null) {
          return 'Du musst auch schon was schreiben!';
        }
        return null;
      },
      onSave: onSave,
      autofocus: true,
    );
  }
}

class PhraseData {
  String course = "";
  String phrase = "";
}
