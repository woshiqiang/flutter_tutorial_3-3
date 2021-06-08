import 'package:flutter/material.dart';
import 'package:flutter_tutorial_3/student.dart';
import 'package:flutter_tutorial_3/student_details.dart';
import 'package:flutter_tutorial_3/tutorial.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

class ScorePage extends StatefulWidget {
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StudentModel(),
      child: Consumer<StudentModel>(builder: buildScaffold),
    );
  }

  Scaffold buildScaffold(BuildContext context, StudentModel model, _) {
    print('build');
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
                Expanded(flex: 2, child: Text('sid')),
                Expanded(flex: 2, child: Text('name')),
                Expanded(flex: 2, child: Text('score')),
              ],
            ),
            //YOUR UI HERE
            Expanded(
              child: ListView.builder(
                  itemBuilder: (_, index) {
                    var item = model.items[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 5),
                        Expanded(flex: 1, child: Text(item.sid)),
                        Expanded(flex: 1, child: Text(item.name)),
                        Expanded(flex: 1, child: Text(total(item))),
                      ],
                    );
                  },
                  itemCount: model.items.length),
            )
          ],
        ),
      ),
    );
  }

  String total(Student student) {
    int sumAttendance = 0;
    int sumScore = 0;
    int sumScoreQ = 0;

    var records = student.records;
    var score = student.score;
    var scoreQ = student.scoreQ;

    for (int i = 0; i < 12; i++) {
      var week = 'week${i + 1}';
      int attendance = records.contains(week) ? 100 : 0;
      sumAttendance += attendance;
      sumScore += score[i];
      sumScoreQ += scoreQ[i];
    }
    int total = (sumAttendance ~/ 12 + sumScore ~/ 5 + sumScoreQ ~/ 5) ~/ 3;
    return '${total}';
  }
}
