import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class AddScheduleView extends StatefulWidget {
  final Firestore db;
  final String userEmail;
  final String userId;

  const AddScheduleView({Key key, this.db, this.userEmail, this.userId}) : super(key: key);
  
  @override
  _AddScheduleViewState createState() => _AddScheduleViewState();
}

const String MIN_DATETIME = '2020-06-01 00:00:00';
const String MAX_DATETIME = '2030-01-01 00:00:00';
const String INIT_DATETIME = '2020-06-01 00:00:00';
const String DATE_FORMAT = 'yyyy-MM-dd, H:m';

class _AddScheduleViewState extends State<AddScheduleView> {
  String _instructor, _proctor, _dropdownCourse, _subjectCode = '';
  DateTime _startDateTime, _endDateTime;
  bool _isLoading;

  @override
  void initState() { 
    super.initState();
    _isLoading = false;
  }

  Widget showInstructorInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        enabled: _isLoading ? false : true,
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Mr. John Doe',
          prefixIcon: Icon(
            Icons.person,
            color: Colors.grey,
          )),
        validator: (value) => value.isEmpty ? 'Instructor can\'t be empty' : null,
        onSaved: (value) => _instructor = value.trim(),
        onChanged: (value) => _instructor = value.trim(),
      ),
    );
  }

  Widget showProctorInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        enabled: _isLoading ? false : true,
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Ms. Jane Doe',
          prefixIcon: Icon(
            Icons.person,
            color: Colors.grey,
          )),
        validator: (value) => value.isEmpty ? 'Proctor can\'t be empty' : null,
        onSaved: (value) => _proctor = value.trim(),
        onChanged: (value) => _proctor = value.trim(),
      ),
    );
  }

  Widget showSubjectInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        enabled: _isLoading ? false : true,
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          hintText: '123-ABC-567',
          prefixIcon: Icon(
            Icons.format_list_numbered,
            color: Colors.grey,
          )),
        validator: (value) => value.isEmpty ? 'Subject Code can\'t be empty' : null,
        onSaved: (value) => _subjectCode = value.trim(),
        onChanged: (value) => _subjectCode = value.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Schedule"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () async {
          setState(() => _isLoading = true);
          await widget.db.collection('schedule').add({
            'course': _dropdownCourse,
            'instructor': _instructor,
            'proctor': _proctor,
            'subject_code': _subjectCode,
            'time_start': _startDateTime,
            'time_end': _endDateTime,
          }); 
          setState(() => _isLoading = false);
          Navigator.of(context).pop();
        },
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(
          horizontal: 40.0,
          vertical: 25.0
        ),
        child: SingleChildScrollView(
          child: Center(
            child: !_isLoading ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StreamBuilder(
                  stream: widget.db.collection('course').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null ||
                        snapshot.connectionState ==
                            ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    var data = snapshot.data.documents;

                    return Column(
                      children: <Widget>[
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
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.book)
                            ),
                            value: 'BS in Information Technology',
                            onChanged: (value) =>
                                setState(() => _dropdownCourse = value),
                            items: [
                              for (int i = 0; i < data.length; i++)
                                DropdownMenuItem(
                                  child: Text(data[i]["name"]),
                                  value: data[i]["name"],
                                )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                ),
                SizedBox(height: 10.0,),
                Container(
                  width: double.maxFinite,
                  child: Bubble(
                    color: Colors.teal[800],
                    elevation: 5.0,
                    child: Text(
                      "Instructor",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                showInstructorInput(),
                SizedBox(height: 10.0,),
                Container(
                  width: double.maxFinite,
                  child: Bubble(
                    color: Colors.teal[800],
                    elevation: 5.0,
                    child: Text(
                      "Proctor",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                showProctorInput(),
                SizedBox(height: 10.0,),
                Container(
                  width: double.maxFinite,
                  child: Bubble(
                    color: Colors.teal[800],
                    elevation: 5.0,
                    child: Text(
                      "Subject Code",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                showSubjectInput(),
                Container(
                  margin: EdgeInsets.only(top: 8.0),
                  decoration: ShapeDecoration(
                    color: Colors.teal[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0)
                      )
                    )
                  ),
                  child: DateTimePickerWidget(
                    minDateTime: DateTime.parse(MIN_DATETIME),
                    maxDateTime: DateTime.parse(MAX_DATETIME),
                    initDateTime: DateTime.parse(INIT_DATETIME),
                    dateFormat: DATE_FORMAT,
                    pickerTheme: DateTimePickerTheme(
                      showTitle: false,
                      pickerHeight: 75.0,
                      title: Container(
                        width: double.infinity,
                        height: 30.0,
                        alignment: Alignment.center,
                        child: Text('Schedule Start (Date - Hour - Mins)', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    onChange: (dateTime, selectedIndex) {
                      _startDateTime = dateTime;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8.0),
                  decoration: ShapeDecoration(
                    color: Colors.teal[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0)
                      )
                    )
                  ),
                  child: DateTimePickerWidget(
                    minDateTime: DateTime.parse(MIN_DATETIME),
                    maxDateTime: DateTime.parse(MAX_DATETIME),
                    initDateTime: DateTime.parse(INIT_DATETIME),
                    dateFormat: DATE_FORMAT,
                    pickerTheme: DateTimePickerTheme(
                      showTitle: false,
                      pickerHeight: 75.0,
                      title: Container(
                        width: double.infinity,
                        height: 30.0,
                        alignment: Alignment.center,
                        child: Text('Schedule End (Year - Day - Month)', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    onChange: (dateTime, selectedIndex) {
                      _endDateTime = dateTime;
                    },
                  ),
                ),

              ],
            ) : CircularProgressIndicator(),
          ),
        )
      )
    );
  }
}
