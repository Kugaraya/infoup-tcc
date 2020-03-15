import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:infoup/core/models/public-handbook.dart';
import 'package:infoup/core/models/public-schedules.dart';
import 'package:infoup/core/services/auth-service.dart';

class PublicDashboard extends StatefulWidget {
  PublicDashboard({Key key, this.auth, this.db}) : super(key: key);

  final Firestore db;
  final BaseAuth auth;
  @override
  _PublicDashboardState createState() => _PublicDashboardState();
}

class _PublicDashboardState extends State<PublicDashboard> {
  List<String> _content = ["Student Guide", "Exam Schedule"];
  List<String> _contentImg = ["handbook.png", "schedule.png"];
  List<Widget> _contentLink;

  @override
  void initState() {
    super.initState();
    _contentLink = [
      PublicHandbook(
        auth: widget.auth,
        db: widget.db,
      ),
      PublicSchedule(
        auth: widget.auth,
        db: widget.db,
      )
    ];
  }

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  formatDate(
                      DateTime.now(), [DD, " - ", MM, " ", dd, ", ", yyyy]),
                  textScaleFactor: 1.3,
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  "Welcome!",
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text(
                  "Slide up/down to navigate",
                  textScaleFactor: 0.8,
                ),
              ),
              Divider(),
              CarouselSlider.builder(
                itemCount: _content.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 300.0,
                    child: Card(
                      elevation: 5.0,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/" + _contentImg[index]),
                                repeat: ImageRepeat.noRepeat,
                                fit: BoxFit.cover)),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => _contentLink[index]));
                          },
                          child: Text(
                            _content[index],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textScaleFactor: 1.8,
                          ),
                          splashColor: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  );
                },
                height: MediaQuery.of(context).size.height * 0.45,
                scrollDirection: Axis.vertical,
                scrollPhysics: FixedExtentScrollPhysics(),
              )
            ],
          ),
        ));
  }
}
