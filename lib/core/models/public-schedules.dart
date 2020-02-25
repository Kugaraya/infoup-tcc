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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exam Schedules"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Schedule"),
      ),
    );
  }
}
