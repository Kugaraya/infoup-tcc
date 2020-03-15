import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoup/core/services/auth-service.dart';

class AboutApp extends StatefulWidget {
  AboutApp(
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
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Material(
            color: Theme.of(context).primaryColor,
            child: InkWell(
              onTap: () {
                showAboutDialog(
                    context: context,
                    applicationIcon: Image.asset("assets/logo.png"),
                    applicationName: "Student Manual",
                    applicationVersion: "1.0c");
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                height: 108.0,
                child: ListTile(
                  leading: Icon(
                    Icons.info,
                    color: Colors.white,
                    size: 60.0,
                  ),
                  title: Text("Student Manual",
                      textScaleFactor: 2.0,
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  subtitle: Text("1.0c",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.date_range),
            ),
            title: Text("Release Date"),
            subtitle: Text("March 30, 2020"),
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.email),
            ),
            title: Text("Contact Us"),
            subtitle: Text(
              "royettebanda@ymail.com",
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Center(
            child: Image.asset("assets/logo.png"),
          ),
          ListTile(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.copyright),
                  Text(
                    " 2020",
                    textScaleFactor: 0.8,
                  )
                ]),
          ),
        ],
      ),
    ));
  }
}
