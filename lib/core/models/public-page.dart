import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'package:infoup/core/services/auth-service.dart';

class PublicPage extends StatefulWidget {
  PublicPage(
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
  _PublicPageState createState() => _PublicPageState();
}

class _PublicPageState extends State<PublicPage> {
  @override
  void initState() {
    super.initState();
  }

  NotusDocument _loadDocument() {
    final Delta delta = Delta()
      ..insert(widget.document["content"] == null
          ? "No content yet, contact administrator if this is a mistake\n"
          : widget.document["content"]);
    return NotusDocument.fromDelta(delta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document["title"]),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ZefyrScaffold(
          child: ZefyrView(
            document: _loadDocument(),
          ),
        ),
      ),
    );
  }
}
