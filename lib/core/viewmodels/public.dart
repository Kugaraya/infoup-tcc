import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoup/core/models/public-dashboard.dart';
import 'package:infoup/core/services/auth-service.dart';
import 'package:infoup/core/viewmodels/about.dart';
import 'package:infoup/ui/views/auth-page.dart';

class PublicViewModel extends StatefulWidget {
  PublicViewModel({Key key, this.auth, this.db, this.loginCallback})
      : super(key: key);

  final Firestore db;
  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  _PublicViewModelState createState() => _PublicViewModelState();
}

class _PublicViewModelState extends State<PublicViewModel> {
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
        title: Text(_currentIndex == 0 ? "Home" : "About"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.lock_open,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AuthPage(
                        auth: widget.auth,
                        db: widget.db,
                        loginCallback: widget.loginCallback,
                      )));
            },
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
          PublicDashboard(
            auth: widget.auth,
            db: widget.db,
          ),
          AboutApp(
            auth: widget.auth,
            db: widget.db,
          ),
        ],
      ),
    );
  }
}
