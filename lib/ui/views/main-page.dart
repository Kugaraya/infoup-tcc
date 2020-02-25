import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoup/core/services/auth-service.dart';
import 'package:infoup/core/viewmodels/admin.dart';

class DashboardMain extends StatefulWidget {
  DashboardMain(
      {Key key,
      this.auth,
      this.userId,
      this.logoutCallback,
      this.userEmail,
      this.db})
      : super(key: key);

  final Firestore db;
  final String userEmail;
  final String userId;
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  @override
  _DashboardMainState createState() => _DashboardMainState();
}

class _DashboardMainState extends State<DashboardMain> {
  @override
  Widget build(BuildContext context) {
    Widget _forScreen() {
      return StreamBuilder(
        stream: widget.db
            .collection('accounts')
            .where("uid", isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          int checker = snapshot.data.documents[0]["permission"];
          switch (checker) {
            case 0:
              return AdminViewModel(
                db: widget.db,
                auth: widget.auth,
                userEmail: widget.userEmail,
                userId: widget.userId,
                logoutCallback: widget.logoutCallback,
              );

            default:
              return Center(
                  child: Text(
                "Account invalid",
                textScaleFactor: 1.4,
              ));
          }
        },
      );
    }

    return Scaffold(body: _forScreen());
  }
}
