import 'package:flutter/material.dart';
import 'package:flutter_tutorial_3/student.dart';

class StudentScorePage extends StatefulWidget {
  final Student student;

  const StudentScorePage({Key key, this.student}) : super(key: key);

  @override
  _StudentScorePageState createState() => _StudentScorePageState();
}

class _StudentScorePageState extends State<StudentScorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('student score'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 5),
                Expanded(flex: 2, child: Text('Week')),
                Expanded(flex: 2, child: Text('attendance')),
                Expanded(flex: 2, child: Text('Quiz')),
                Expanded(flex: 2, child: Text('Self work')),
              ],
            ),
            //YOUR UI HERE
            Expanded(
              child: ListView.builder(
                  itemBuilder: (_, index) {
                    var i = index + 1;
                    var week = 'week$i';
                    var item = widget.student;
                    var score = item.score;
                    var records = item.records;
                    var a = records.contains(week) ? '100' : '0';
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 5),
                        Expanded(flex: 1, child: Text(week)),
                        Expanded(flex: 1, child: Text(a)),
                        Expanded(flex: 1, child: Text('0')),
                        Expanded(flex: 1, child: Text('0')),
                      ],
                    );
                  },
                  itemCount: 12),
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 5),
                Expanded(flex: 2, child: Text('Week')),
                Expanded(flex: 2, child: Text('attendance')),
                Expanded(flex: 2, child: Text('Quiz')),
                Expanded(flex: 2, child: Text('Self work')),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
