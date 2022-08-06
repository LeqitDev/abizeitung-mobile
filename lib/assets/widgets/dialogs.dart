import 'dart:io';

import 'package:flutter/material.dart';

class RetryConnectionDialog {
  bool _active = false;
  final tstyle = const TextStyle(color: Color(0xFFFFFFFF));

  void launchDialog(BuildContext context, Function func, int errorCode) {
    if (_active) return;
    _active = true;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Verbindung fehlgeschlagen!",
              style: tstyle,
            ),
            content: Text(
              "Die Verbindung zum Server konnte nicht hergestellt werden!\nStelle sicher, dass du mit dem Internet verbunden bist.\nError Code: $errorCode",
              style: tstyle,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  func();
                  _dismissDialog(context);
                },
                child: const Text("Okay"),
                // style: ButtonStyle(backgroundColor: MaterialStateProp Color(0xFFACFCD9)),
              )
            ],
            backgroundColor: const Color(0xFF3B413C),
          );
        });
  }

  _dismissDialog(context) {
    Navigator.pop(context);
  }
}

class DeleteCommentDialog {
  bool _active = false;
  final tstyle = const TextStyle(color: Color(0xFFFFFFFF));

  void launchDialog(BuildContext context, Function func) {
    if (_active) return;
    _active = true;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Kommentar löschen!",
              style: tstyle,
            ),
            content: Text(
              "Bist du dir sicher, dass du diesen Kommentar löschen willst?",
              style: tstyle,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _dismissDialog(context);
                },
                child: const Text("Nein"),
                // style: ButtonStyle(backgroundColor: MaterialStateProp Color(0xFFACFCD9)),
              ),
              TextButton(
                onPressed: () {
                  func();
                  _dismissDialog(context);
                },
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFB02E0C)),
                child: const Text(
                  "Ja, löschen",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            backgroundColor: const Color(0xFF3B413C),
          );
        });
  }

  _dismissDialog(context) {
    Navigator.pop(context);
  }
}

/* class AddCommentDialog {
  String addComment = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void launchDialog(
      BuildContext context, AppStore appStore, int userId, String type) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Kommentar hinzufügen"),
            content: Form(
              child: TextFormField(
                validator: (value) {
                  if (value == null) {
                    return 'Du musst ein Passwort angeben!';
                  }
                  return null;
                },
                onSaved: (value) {
                  addComment = value!.replaceAll('\n', '');
                },
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Kommentar',
                  labelStyle: TextStyle(
                    color: Colors.blue,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              key: _formKey,
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    _dismissDialog(context);
                  },
                  child: Text(
                    'Abbrechen',
                    style: TextStyle(color: Colors.blue[700]),
                  )),
              TextButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();
                  Comment().add(appStore, userId, appStore.api.usr.getID,
                      addComment, type);
                  _dismissDialog(context);
                },
                child: const Text(
                  'Hinzufügen',
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          );
        });
  }

  _dismissDialog(context) {
    Navigator.pop(context);
  }
}

class CommentDetailDialog {
  void launchDialog(BuildContext context, AppStore appStore, Comment comment) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Kommentardetails"),
            content: Table(
              border: const TableBorder(),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    const Text("ID:"),
                    Text(comment.getID.toString()),
                  ],
                ),
                TableRow(
                  children: [
                    const Text("Kommentar:"),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(comment.getComment),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text("Für:"),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(AppStore()
                          .getStudentFromId(comment.getUserID, appStore)!
                          .getName),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text("Von:"),
                    Text(AppStore()
                        .getStudentFromId(comment.getAuthorID, appStore)!
                        .getName),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _dismissDialog(context);
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }

  _dismissDialog(context) {
    Navigator.pop(context);
  }
} */
