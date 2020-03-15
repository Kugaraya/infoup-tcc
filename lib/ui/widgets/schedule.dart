import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Schedules {
  Schedules(this._db);
  final Firestore _db;

  Widget scheduleBuilder() {
    return StreamBuilder(
      stream: this._db.collection("schedule").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget scheduleFiltered(String _course, String _year, String _search) {}
}
