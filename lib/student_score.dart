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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List list = [];
    list.add({
      "Week": "Week",
      "Attendance": "attendance",
      "Quiz": "Quiz",
      "Self work": "Self work"
    });
    var records = widget.student.records;
    var score = widget.student.score;
    var scoreQ = widget.student.scoreQ;
    int sumAttendance = 0;
    int sumScore = 0;
    int sumScoreQ = 0;

    for (int i = 0; i < 12; i++) {
      var week = 'week${i + 1}';
      int attendance = records.contains(week) ? 100 : 0;
      sumAttendance += attendance;
      sumScore += score[i];
      sumScoreQ += scoreQ[i];

      Map map = {
        "Week": week,
        "Attendance": attendance.toString(),
        "Quiz": score[i].toString(),
        "Self work": scoreQ[i].toString()
      };
      list.add(map);
    }

    list.add({
      "Week": "Total mark",
      "Attendance": "${sumAttendance ~/ 12}",
      "Quiz": "${sumScore ~/ 5}",
      "Self work": "${sumScoreQ ~/ 5}"
    });

    int total = (sumAttendance ~/ 12 + sumScore ~/ 5 + sumScoreQ ~/ 5) ~/ 3;

    return Scaffold(
      appBar: AppBar(
        title: Text('student score'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemBuilder: (_, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 5),
                        Expanded(flex: 1, child: Text(list[index]['Week'])),
                        Expanded(
                            flex: 1, child: Text(list[index]['Attendance'])),
                        Expanded(flex: 1, child: Text(list[index]['Quiz'])),
                        Expanded(
                            flex: 1, child: Text(list[index]['Self work'])),
                      ],
                    );
                  },
                  itemCount: list.length),
            ),
            InkWell(
              onTap: (){

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/share_foreground.png",
                    fit: BoxFit.cover,
                    width: 60,
                  ),
                  Text(
                    'student grade is：$total',
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
