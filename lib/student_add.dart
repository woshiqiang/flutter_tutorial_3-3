import 'package:flutter/material.dart';

/// add student
class StudentAddPage extends StatefulWidget {
  @override
  _StudentAddState createState() => _StudentAddState();
}

class _StudentAddState extends State<StudentAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Student'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'id',
                contentPadding: EdgeInsets.only(left: 15),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'name',
                contentPadding: EdgeInsets.only(left: 15),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'email',
                contentPadding: EdgeInsets.only(left: 15),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'course',
                contentPadding: EdgeInsets.only(left: 15),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("submit"),
            )
          ],
        ),
      ),
    );
  }
}
