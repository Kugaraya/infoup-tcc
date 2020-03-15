import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:infoup/core/services/zefyr-image-delegate.dart';
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

  _loadDocument() {
    FirebaseStorage rStorage = FirebaseStorage.instance;
    StorageReference rRef = rStorage.ref().child(
        "content/" + widget.document["title"].replaceAll(" ", "_") + ".json");
    String path = Directory.systemTemp.path +
        "/" +
        widget.document["title"].replaceAll(" ", "_") +
        ".json";
    File read = File(path);
    rRef.writeToFile(read);

    if (read.existsSync()) {
      final contents = read.readAsStringSync();
      return NotusDocument.fromJson(jsonDecode(contents));
    }
    final Delta delta = Delta()..insert("\n");
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
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ZefyrView(
              document: _loadDocument(),
              imageDelegate: CustomImageDelegate(),
            ),
          ),
        ),
      ),
    );
  }
}
