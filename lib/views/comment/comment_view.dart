import 'package:abizeitung_mobile/assets/assets.dart';
import 'package:abizeitung_mobile/assets/widgets/dialogs.dart';
import 'package:abizeitung_mobile/models/comment_model.dart';
import 'package:abizeitung_mobile/stores/app/app_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({Key? key}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<AppStore>(context);
    appStore.updateAppUserComments(appStore);

    return Observer(builder: (context) {
      if (appStore.haveComments) {
        bool hasNewComments = false;
        bool hasOldComments = false;
        for (var comment in appStore.comments) {
          if (comment.isNew) {
            hasNewComments = true;
          } else {
            hasOldComments = true;
          }
        }
        List<Widget> children = [];
        if (hasNewComments) {
          children.addAll([
            const Padding(
              padding: EdgeInsets.only(left: 10.0, bottom: 5.0),
              child: Text(
                'Neue Kommentare',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            for (var comment in appStore.comments.reversed)
              if (comment.isNew) commentCardWidget(comment, appStore),
          ]);
        }
        if (hasOldComments && hasNewComments) {
          children.add(const Padding(padding: EdgeInsets.only(top: 10.0)));
        }
        if (hasOldComments) {
          children.addAll([
            const Padding(
              padding: EdgeInsets.only(left: 10.0, bottom: 5.0),
              child: Text(
                'Ältere Kommentare',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            for (var comment in appStore.comments.reversed)
              if (!comment.isNew) commentCardWidget(comment, appStore),
          ]);
        }
        return ShaderMask(
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
          child: ListView(
            controller: _scrollController,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 70.0),
            children: children,
          ),
        );
      }
      return Container();
    });
  }

  Widget commentCardWidget(Comment comment, AppStore appStore) {
    return Card(
      color: lighterSecondaryColor,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTileTheme(
        textColor: Colors.white,
        contentPadding: const EdgeInsets.only(left: 7.0),
        child: ListTile(
          title: Text(comment.getComment),
          trailing: IconButton(
            icon:
                Icon(Icons.delete_outline, color: primaryColor.withAlpha(225)),
            onPressed: () {
              deleteCommentAction(comment, appStore);
            },
          ),
        ),
      ),
    );
  }

  deleteCommentAction(Comment comment, AppStore appStore) {
    DeleteCommentDialog().launchDialog(context, () {
      setState(() {
        comment.delete(appStore);
        appStore.loadAppUsersComments(appStore);
      });
    });
  }
}
