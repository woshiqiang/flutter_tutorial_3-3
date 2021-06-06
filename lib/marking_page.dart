import 'package:flutter/material.dart';
import 'package:flutter_tutorial_3/student.dart';
import 'package:flutter_tutorial_3/student_details.dart';
import 'package:flutter_tutorial_3/tutorial.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

class MarkingPage extends StatefulWidget {
  String week = 'week1';
  @override
  _MarkingPageState createState() => _MarkingPageState();
}

class _MarkingPageState extends State<MarkingPage> {
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
        title: Text('Marking'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              //下拉列表
              items: <String>[
                'week1',
                'week2',
                'week3',
                'week4',
                'week5',
                'week6',
                'week7',
                'week8',
                'week9',
                'week10',
                'week11',
                'week12',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  //下拉项
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {

                setState(() {
                  widget.week = _;
                });
              },
              value: widget.week,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 5),
                Expanded(flex: 2, child: Text('sid')),
                Expanded(flex: 2, child: Text('name')),
                Expanded(flex: 2, child: Text('Attendance')),
                Expanded(flex: 1, child: Text('SQ')),
                Expanded(flex: 1, child: Text('SS')),
              ],
            ),
            //YOUR UI HERE
            Expanded(
              child: ListView.builder(
                  itemBuilder: (_, index) {
                    var item = model.items[index];
                    bool b = item.records.contains(widget.week);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 5),
                        Expanded(flex: 1, child: Text(item.sid)),
                        Expanded(flex: 1, child: Text(item.name)),
//                        Text(item.records.toString()),
                        Expanded(
                            flex: 1,
                            child: Checkbox(
                              value: b,
                              onChanged: (bool b) {
                                print('sssssss');
                                if (b) {
                                  item.records.add(widget.week);
                                } else {
                                  item.records.remove(widget.week);
                                }

                                model.update(item.id, item);
                              },
                            )),
                        ElevatedButton(onPressed: () {}, child: Text('SQ')),
                        SizedBox(width: 5),
                        ElevatedButton(onPressed: () {}, child: Text('SS')),
                        SizedBox(width: 5),
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
}
