import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'package:infoup/core/services/auth-service.dart';

class AdminPage extends StatefulWidget {
  AdminPage(
      {Key key,
      this.userEmail,
      this.userId,
      this.auth,
      this.logoutCallback,
      this.db,
      this.document})
      : super(key: key);

  final Firestore db;
  final String userEmail;
  final String userId;
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final DocumentSnapshot document;

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  NotusDocument _loadDocument() {
    final Delta delta = Delta()
      ..insert(widget.document["content"] == null
          ? "\n"
          : widget.document["content"]);
    return NotusDocument.fromDelta(delta);
  }

  void _saveDocument() async {
    try {
      await widget.db
          .collection("pages")
          .document(widget.document.documentID)
          .updateData({"content": _controller.document.toPlainText() + "\n"});
      Fluttertoast.showToast(
          msg: "Content Updated",
          backgroundColor: Colors.black54,
          textColor: Colors.white);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.black54,
          textColor: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document["title"]),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete_forever,
              color: Colors.white,
            ),
            onPressed: () => showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => AlertDialog(
                      title: Text("Alert!"),
                      content: Text("Delete this page?"),
                      actions: <Widget>[
                        RaisedButton(
                          elevation: 5.0,
                          onPressed: () async {
                            await widget.db
                                .collection("pages")
                                .document(widget.document.documentID)
                                .delete();
                            Fluttertoast.showToast(
                                msg: "Page Deleted",
                                backgroundColor: Colors.red,
                                textColor: Colors.white);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          color: Colors.blue,
                          child: Text("Confirm"),
                        ),
                        RaisedButton(
                          elevation: 5.0,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.red,
                          child: Text("Cancel"),
                        ),
                      ],
                    )),
          ),
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () => showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => AlertDialog(
                      title: Text("Alert!"),
                      content: Text("Save this content?"),
                      actions: <Widget>[
                        RaisedButton(
                          elevation: 5.0,
                          onPressed: () {
                            _saveDocument();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          color: Colors.blue,
                          child: Text("Confirm"),
                        ),
                        RaisedButton(
                          elevation: 5.0,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.red,
                          child: Text("Cancel"),
                        ),
                      ],
                    )),
          )
        ],
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(16),
          controller: _controller,
          focusNode: _focusNode,
          physics: BouncingScrollPhysics(),
        ),
      ),
    );
  }
}
