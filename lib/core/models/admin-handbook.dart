import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infoup/core/models/admin-page.dart';
import 'package:infoup/core/services/auth-service.dart';

class AdminHandbook extends StatefulWidget {
  AdminHandbook(
      {Key key,
      this.userEmail,
      this.userId,
      this.auth,
      this.logoutCallback,
      this.db})
      : super(key: key);

  final Firestore db;
  final String userEmail;
  final String userId;
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  @override
  _AdminHandbookState createState() => _AdminHandbookState();
}

class _AdminHandbookState extends State<AdminHandbook> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  int _pageCount;
  String _pageTitle;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        await widget.db
            .collection("pages")
            .add({"title": _pageTitle, "sequence": _pageCount});

        _formKey.currentState.reset();
        Fluttertoast.showToast(
            msg: "Page Successfully Added",
            backgroundColor: Colors.green,
            textColor: Colors.white);
        Navigator.of(context).pop();
      } catch (e) {
        setState(() {
          _formKey.currentState.reset();
          Fluttertoast.showToast(
              msg: "Error: $e",
              backgroundColor: Colors.red,
              textColor: Colors.white);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SafeArea(
        child: Container(
          width: 200.0,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: StreamBuilder(
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
                _pageCount = data != null ? data.length : 0;
                return data.length != 0
                    ? ListView.builder(
                      physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                    AdminPage(
                                      auth: widget.auth,
                                      db: widget.db,
                                      userEmail:
                                          widget.userEmail,
                                      userId: widget.userId,
                                      logoutCallback: widget
                                          .logoutCallback,
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
                                    textScaleFactor: 1.1,
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
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("Student Guide"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.add_box,
                color: Colors.white,
              ),
              onPressed: () => _scaffoldKey.currentState.showBottomSheet(
                    (context) => Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                initialValue: (_pageCount + 1).toString(),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.format_list_numbered),
                                  labelText: "Page Number",
                                ),
                                onChanged: (value) =>
                                    _pageCount = int.parse(value),
                                onSaved: (value) =>
                                    _pageCount = int.parse(value),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.view_array),
                                  labelText: "Page Title",
                                ),
                                onChanged: (value) => _pageTitle = value,
                                onSaved: (value) => _pageTitle = value,
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                                  child: SizedBox(
                                    height: 40.0,
                                    child: RaisedButton(
                                      elevation: 5.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      color: Theme.of(context).primaryColor,
                                      child: Text('Add Page',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white)),
                                      onPressed: validateAndSubmit,
                                    ),
                                  )),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "Swipe down to cancel",
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.3,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.arrow_downward,
                                    color: Colors.grey,
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                    elevation: 5.0,
                  )),
          StreamBuilder(
              stream: widget.db.collection("pages").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                var data = snapshot.data.documents;
                _pageCount = data != null ? data.length : 0;
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
                _pageCount = data != null ? data.length : 0;
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
                                            builder: (context) => AdminPage(
                                                  auth: widget.auth,
                                                  db: widget.db,
                                                  userEmail: widget.userEmail,
                                                  userId: widget.userId,
                                                  logoutCallback:
                                                      widget.logoutCallback,
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
                            "Oops, I can't fetch any page. Add a page by tapping the button at the top-right portion of the screen",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
              })),
    );
  }
}
