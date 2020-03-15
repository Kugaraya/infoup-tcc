import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoup/core/services/auth-service.dart';

class PublicSchedule extends StatefulWidget {
  PublicSchedule({Key key, this.auth, this.db}) : super(key: key);

  final Firestore db;
  final BaseAuth auth;
  @override
  _PublicScheduleState createState() => _PublicScheduleState();
}

class _PublicScheduleState extends State<PublicSchedule> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSearch = false;
  String _search;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Container(
        width: 200.0,
        height: double.maxFinite,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                topLeft: Radius.circular(8.0))),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Dropdown Here"),
              ),
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Dropdown Here"),
              ),
            ],
          ),
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
                      hintText: "Subject Code",
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
              : Container(),
          IconButton(
            onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
            icon: Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: Text("Schedule"),
      ),
    );
  }
}
