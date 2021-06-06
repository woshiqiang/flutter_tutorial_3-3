import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial_3/student.dart';
import 'package:flutter_tutorial_3/student_score.dart';

class StudentInfo extends StatefulWidget {
  final Student student;
  const StudentInfo({Key key, this.student}) : super(key: key);

  @override
  _StudentInfoState createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Information'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Student Information',
              style: TextStyle(
                fontSize: 30,
                color: Colors.blue,
              ),
            ),
            Image.asset(
              "assets/avatar_foreground.png",
              fit: BoxFit.cover,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Name:'),
                Text(widget.student.name),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('SID:'),
                Text(widget.student.sid),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Email:'),
                Text(widget.student.email),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Course:'),
                Text(widget.student.course),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(child: Text('student score'),onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return StudentScorePage(student: widget.student,);
                      }));
                },),
                SizedBox(width: 40,),
                ElevatedButton(child: Text('remove'),onPressed: (){},),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
