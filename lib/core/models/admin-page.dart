import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infoup/core/services/zefyr-image-delegate.dart';
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
    _loadDocument().then(
        (document) => setState(() => _controller = ZefyrController(document)));
    _focusNode = FocusNode();
  }

  Future<NotusDocument> _loadDocument() async {
    FirebaseStorage rStorage = FirebaseStorage.instance;
    StorageReference rRef = rStorage.ref().child(
        "content/" + widget.document["title"].replaceAll(" ", "_") + ".json");
    String path = Directory.systemTemp.path +
        "/" +
        widget.document["title"].replaceAll(" ", "_") +
        ".json";
    File read = File(path);
    rRef.writeToFile(read);

    if (await read.exists()) {
      final contents = await read.readAsString();
      return NotusDocument.fromJson(jsonDecode(contents));
    }

    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }

  @override
  Widget build(BuildContext context) {
    void _saveDocument() async {
      try {
        final contents = jsonEncode(_controller.document);
        final path = Directory.systemTemp.path +
            "/" +
            widget.document["title"].replaceAll(" ", "_") +
            ".json";
        final file = File(path);

        await file.writeAsString(contents).then((_) async {
          FirebaseStorage fStorage = FirebaseStorage.instance;
          StorageReference sRef = fStorage.ref().child("content/" +
              widget.document["title"].replaceAll(" ", "_") +
              ".json");

          final StorageUploadTask uploadTask = sRef.putFile(file);
          final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
          final String url = await downloadUrl.ref.getDownloadURL();

          widget.db
              .collection("pages")
              .document(widget.document.documentID)
              .updateData({"content": url});
        });
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
        child: _controller == null
            ? Center(child: CircularProgressIndicator())
            : ZefyrEditor(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8.0),
                controller: _controller,
                focusNode: _focusNode,
                imageDelegate: CustomImageDelegate(),
                physics: BouncingScrollPhysics(),
              ),
      ),
    );
  }
}
