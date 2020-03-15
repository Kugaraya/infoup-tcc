import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoup/core/services/auth-service.dart';

class AdminSchedule extends StatefulWidget {
  AdminSchedule(
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
  _AdminScheduleState createState() => _AdminScheduleState();
}

class _AdminScheduleState extends State<AdminSchedule> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSearch = false;
  String _dropdownYear;
  String _dropdownCourse;
  String _search;

  @override
  void initState() {
    super.initState();
    _dropdownYear = "";
    _dropdownCourse = "";
    _search = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      endDrawer: Container(
        width: 200.0,
        height: MediaQuery.of(context).size.height * 0.60,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                topLeft: Radius.circular(8.0))),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(8.0))),
              width: double.maxFinite,
              height: 40.0,
              child: Text(
                "Filters",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        width: double.maxFinite,
                        child: Bubble(
                          color: Colors.teal[800],
                          elevation: 5.0,
                          child: Text(
                            "Academic Year",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      StreamBuilder(
                          stream: widget.db.collection("acad-year").snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null ||
                                snapshot.connectionState ==
                                    ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            var data = snapshot.data.documents;

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 12.0),
                              child: DropdownButtonFormField(
                                itemHeight: 50.0,
                                onChanged: (value) =>
                                    setState(() => _dropdownYear = value),
                                items: [
                                  for (int i = 0; i < data.length; i++)
                                    DropdownMenuItem(
                                      child: Text(data[i]["desc"]),
                                    )
                                ],
                              ),
                            );
                          }),
                      Container(
                        width: double.maxFinite,
                        child: Bubble(
                          color: Colors.teal[800],
                          elevation: 5.0,
                          child: Text(
                            "Course",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      StreamBuilder(
                          stream: widget.db.collection("course").snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null ||
                                snapshot.connectionState ==
                                    ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            var data = snapshot.data.documents;

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 12.0),
                              child: DropdownButtonFormField(
                                onChanged: (value) =>
                                    setState(() => _dropdownCourse = value),
                                items: [
                                  for (int i = 0; i < data.length; i++)
                                    DropdownMenuItem(
                                      child: Text(data[i]["name"]),
                                    )
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _dropdownYear = "";
                              _dropdownCourse = "";
                              _search = "";
                            });
                          },
                          child: Text("Reset"),
                          color: Colors.grey,
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text("Edit Filters"),
                          color: Colors.red[300],
                        )
                      ]),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: !_isSearch
            ? Text("Exam Schedules")
            : Container(
                height: 40.0,
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0)),
                child: TextField(
                    onChanged: (text) => _search = text,
                    autofocus: true,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "ex. Subject Code",
                      hintStyle: TextStyle(color: Colors.black54),
                    )),
              ),
        centerTitle: true,
        actions: <Widget>[
          !_isSearch
              ? IconButton(
                  onPressed: () =>
                      setState(() => _isSearch = _isSearch ? false : true),
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                )
              : IconButton(
                  onPressed: () =>
                      setState(() => _isSearch = _isSearch ? false : true),
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                ),
          IconButton(
            onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
            icon: Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}
