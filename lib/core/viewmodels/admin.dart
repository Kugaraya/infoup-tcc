import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoup/core/models/admin-dashboard.dart';
import 'package:infoup/core/services/auth-service.dart';
import 'package:infoup/core/viewmodels/about.dart';

class AdminViewModel extends StatefulWidget {
  AdminViewModel(
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
  _AdminViewModelState createState() => _AdminViewModelState();
}

class _AdminViewModelState extends State<AdminViewModel> {
  PageController _pageController;
  int _currentIndex;
  @override
  void initState() {
    super.initState();

    _currentIndex = 0;
    _pageController =
        PageController(initialPage: _currentIndex, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        elevation: 5.0,
        onTap: (index) {
          setState(() {
            _pageController.jumpToPage(index);
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              title: Text(""),
              icon: Icon(Icons.local_library, size: 30, color: Colors.white),
              activeIcon:
                  Icon(Icons.local_library, size: 40, color: Colors.white),
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              title: Text(""),
              icon: Icon(Icons.help, size: 30, color: Colors.white),
              activeIcon: Icon(Icons.help, size: 40, color: Colors.white),
              backgroundColor: Theme.of(context).accentColor),
        ],
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Admin Mode"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.lock_outline,
              color: Colors.white,
            ),
            onPressed: () => showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("Logout?"),
                      actions: <Widget>[
                        RaisedButton(
                          onPressed: widget.logoutCallback,
                          child: Text("Confirm"),
                          color: Theme.of(context).primaryColor,
                        ),
                        RaisedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("Cancel"),
                          color: Colors.red,
                        ),
                      ],
                    )),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: <Widget>[
          AdminDashboard(
            auth: widget.auth,
            db: widget.db,
            logoutCallback: widget.logoutCallback,
            userEmail: widget.userEmail,
            userId: widget.userId,
          ),
          AboutApp(
            auth: widget.auth,
            db: widget.db,
            logoutCallback: widget.logoutCallback,
            userEmail: widget.userEmail,
            userId: widget.userId,
          ),
        ],
      ),
    );
  }
}
