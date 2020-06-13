import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoup/core/models/public-page.dart';
import 'package:infoup/core/services/auth-service.dart';

class PublicHandbook extends StatefulWidget {
  PublicHandbook({Key key, this.auth, this.db}) : super(key: key);

  final Firestore db;
  final BaseAuth auth;
  @override
  _PublicHandbookState createState() => _PublicHandbookState();
}

class _PublicHandbookState extends State<PublicHandbook> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Student Guide"),
        centerTitle: true,
        actions: <Widget>[
          StreamBuilder(
              stream: widget.db.collection("pages").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                var data = snapshot.data.documents;
                return data.length != 0
                    ? IconButton(
                        icon: Icon(Icons.list, color: Colors.white),
                        onPressed: () =>
                            _scaffoldKey.currentState.openEndDrawer(),
                      )
                    : Container();
              }),
        ],
      ),
      endDrawer: SafeArea(
        child: Material(
          color: Colors.white,
          child: Container(
            width: 200.0,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  height: 40.0,
                  color: Theme.of(context).primaryColor,
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Pages",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      StreamBuilder(
                          stream: widget.db
                              .collection("pages")
                              .orderBy("sequence")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData ||
                                snapshot.connectionState ==
                                    ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            var data = snapshot.data.documents;
                            return data.length != 0
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PublicPage(
                                                        auth: widget.auth,
                                                        db: widget.db,
                                                        document: data[index],
                                                      )));
                                        },
                                        splashColor:
                                            Theme.of(context).primaryColor,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black45,
                                                  width: 0.66,
                                                  style: BorderStyle.solid)),
                                          child: ListTile(
                                            leading: Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Text(
                                                data[index]["sequence"]
                                                        .toString() +
                                                    ".",
                                                textScaleFactor: 1.2,
                                              ),
                                            ),
                                            title: Text(data[index]["title"]),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container();
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
          child: StreamBuilder(
              stream:
                  widget.db.collection("pages").orderBy("sequence").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                var data = snapshot.data.documents;

                return data.length != 0
                    ? CarouselSlider.builder(
                        options: CarouselOptions(
                          scrollPhysics: BouncingScrollPhysics(),
                          height: MediaQuery.of(context).size.height * 0.80,
                          enlargeCenterPage: true,
                        ),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.80,
                            width: MediaQuery.of(context).size.width * 0.80,
                            child: Card(
                              elevation: 5.0,
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage("assets/" +
                                            (Random().nextInt(15) + 1)
                                                .toString() +
                                            ".jpg"),
                                        fit: BoxFit.fill,
                                        colorFilter: ColorFilter.mode(
                                            Colors.black54,
                                            BlendMode.hardLight))),
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => PublicPage(
                                                  auth: widget.auth,
                                                  db: widget.db,
                                                  document: data[index],
                                                )));
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(""),
                                      Text(
                                        data[index]["title"],
                                        style: TextStyle(
                                            color: Colors.white,
                                            backgroundColor:
                                                Colors.transparent),
                                        textScaleFactor: 1.8,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        data[index]["sequence"].toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            backgroundColor:
                                                Colors.transparent),
                                        textScaleFactor: 1.5,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  splashColor: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: Text(
                            "Oops, I can't fetch any page. Report to the admininistrator if this was a mistake",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
              })),
    );
  }
}
