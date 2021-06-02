import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentInfo extends StatefulWidget {
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
                Text('tom'),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ID:'),
                Text('tom'),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Email:'),
                Text(''),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Course:'),
                Text(''),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
