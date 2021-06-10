
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial_3/student.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

List scheme = ["week1", "week3", "week5", "week8", "week10"];
List schemeWeekId = [0, 2, 4, 7, 9];
List hdLevel = ["HD+", "HD", "DN", "CR", "PP", "NN"];
List abcLevel = ["A", "B", "C", "D", "F"];
List multipleC = ["CheckPoint 1", "CheckPoint 2", "CheckPoint 3"];
List schemeSp = [
  "Multiple checkboxes",
  "Score out of 100",
  "HD/DN/CR/PP/NN",
  "A/B/C/D/F"
];

// ignore: must_be_immutable
class MarkingPage extends StatefulWidget {
  String week = 'week1';
  int weekIndex = 0;
  int schemeId = 0;
  String mode = "Multiple checkboxes";

  @override
  _MarkingPageState createState() => _MarkingPageState();
}

class _MarkingPageState extends State<MarkingPage> {
  CollectionReference stateCollection =
      FirebaseFirestore.instance.collection('state2');
  final scoreController = TextEditingController();

  List checkList = [];

  @override
  void initState() {
    var future = stateCollection.doc(widget.week).get();
    future.then((value) {
      var data = value.data();
      if (data == null) {
        return;
      }
      if (data.containsKey('scheme')) {
        print(data['scheme']);
        setState(() {
          widget.mode = data['scheme'];
        });
      }
    });
    super.initState();
  }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
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
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {

                    setState(() {
                      widget.week = _;
                      widget.weekIndex =
                          int.parse(_.substring(4, _.length)) - 1;
                    });

                    var future = stateCollection.doc(widget.week).get();
                    future.then((value) {
                      var data = value.data();
                      if (data == null) {
                        return;
                      }
                      if (data.containsKey('scheme')) {
                        print(data['scheme']);
                        setState(() {
                          widget.mode = data['scheme'];
                        });
                      }
                    });


                  },
                  value: widget.week,
                ),
                DropdownButton<String>(
                  items: <String>[
                    'Multiple checkboxes',
                    'Score out of 100',
                    'HD/DN/CR/PP/NN',
                    'A/B/C/D/F',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {
                    setState(() {
                      widget.mode = _;
                    });
                  },
                  value: widget.mode,
                ),
                ElevatedButton(
                    onPressed: () {
                      var future = stateCollection.doc(widget.week).get();
                      future.then((value) {
                        var data = value.data();
                        if (data == null) {
                          Fluttertoast.showToast(msg: "请先设置打分模式");
                          return;
                        }
                        if (data.containsKey('scheme')) {
                          print(data['scheme']);
                          setState(() {
                            widget.mode = data['scheme'];
                          });
                        }
                      });
                    },
                    child: Text('SET')),
                SizedBox(
                  width: 2,
                ),
               Expanded(child:  ElevatedButton(
                   onPressed: () {
                     stateCollection
                         .doc(widget.week)
                         .set({'scheme': widget.mode});
                     model.items.forEach((s) {
                       s.score[widget.weekIndex] = 0;
                       switch (widget.mode) {
                         case 'Multiple checkboxes':
                           var list = [];
                           for (int i1 = 0; i1 < multipleC.length; i1++) {
                             list.add(false);
                           }
                           s.qm[widget.week] = list;
                           s.sm[widget.week] = list;
                           break;
                         case 'Score out of 100':
                           s.qm[widget.week] = 0;
                           s.sm[widget.week] = 0;
                           break;
                         case 'HD/DN/CR/PP/NN':
                           s.qm[widget.week] = 5;
                           s.sm[widget.week] = 5;
                           break;
                         case 'A/B/C/D/F':
                           s.qm[widget.week] = 4;
                           s.sm[widget.week] = 4;
                           break;
                       }
                       model.update(s.id, s);
                     });
                     model.fetch();
                     Fluttertoast.showToast(msg: 'Success!');
                   },
                   child: Text('RESET')),)
              ],
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
                                if (b) {
                                  item.records.add(widget.week);
                                } else {
                                  item.records.remove(widget.week);
                                }

                                model.update(item.id, item);
                              },
                            )),
                        ElevatedButton(
                            onPressed: () {
                              switch (widget.mode) {
                                case 'Multiple checkboxes':
                                  _mul(0, item, model);
                                  break;
                                case 'Score out of 100':
                                  _score(0, item, model);
                                  break;
                                case 'HD/DN/CR/PP/NN':
                                  _hq(0, item, model,0);
                                  break;
                                case 'A/B/C/D/F':
                                  _hq(0, item, model,1);
                                  break;
                              }
                            },
                            child: Text('SQ')),
                        SizedBox(width: 5),
                        ElevatedButton(
                            onPressed: () {
                              switch (widget.mode) {
                                case 'Multiple checkboxes':
                                  _mul(1, item, model);
                                  break;
                                case 'Score out of 100':
                                  _score(1, item, model);
                                  break;
                                case 'HD/DN/CR/PP/NN':
                                  _hq(1, item, model,0);
                                  break;
                                case 'A/B/C/D/F':
                                  _hq(1, item, model,1);
                              }
                            },
                            child: Text('SS')),
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

  void _mul(int type, Student item, StudentModel model) {
    checkList.clear();
    if (type == 0) {
      if (item.qm.containsKey(widget.week)) {
        checkList.addAll(item.qm[widget.week]);
      } else {
        for (int i = 0; i < multipleC.length; i++) {
          checkList.add(false);
        }
      }
    } else {
      if (item.sm.containsKey(widget.week)) {
        checkList.addAll(item.sm[widget.week]);
      } else {
        for (int i = 0; i < multipleC.length; i++) {
          checkList.add(false);
        }
      }
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Multiple checkboxes'),
            content: Material(
              color: Colors.white10,
              child: MulDialog(
                checkList: checkList,
              ),
            ),
            actions: <Widget>[
              new CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(context).pop('Cancel');
                },
                child: new Text('Cancel'),
              ),
              new CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(context).pop('Accept');

                  int s = 0;
                  for (var b in checkList) {
                    if (b) {
                      s++;
                    }
                  }
                  if (type == 0) {
                    item.qm[widget.week] = checkList;
                    item.score[widget.weekIndex] = s * 100 ~/ multipleC.length;
                  } else {
                    item.sm[widget.week] = checkList;
                    item.scoreQ[widget.weekIndex] = s * 100 ~/ multipleC.length;
                  }
                  model.update(item.id, item);
                  model.fetch();
                },
                child: new Text('Sure'),
              ),
            ],
          );
        });
  }

  void _score(int type, Student item, StudentModel model) {
    int score = 0;
    if (type == 0) {
      if (item.qm.containsKey(widget.week)) {
        score = item.qm[widget.week].toInt();
      }
    } else {
      if (item.sm.containsKey(widget.week)) {
        score = item.sm[widget.week].toInt();
      }
    }

    scoreController.text = score.toString();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Multiple checkboxes'),
            content: Material(
              color: Colors.white10,
              child: TextField(
                controller: scoreController,
              ),
            ),
            actions: <Widget>[
              new CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(context).pop('Cancel');
                },
                child: new Text('Cancel'),
              ),
              new CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(context).pop('Accept');

                  if (type == 0) {
                    var scoreNow = int.tryParse(scoreController.text);
                    if(scoreNow == null){
                      Fluttertoast.showToast(msg: "录入格式有误");
                      return;
                    }
                    if(scoreNow<0||scoreNow>100){
                      Fluttertoast.showToast(msg: '请录入0-100的整数');
                      return;
                    }
                    item.qm[widget.week] = int.parse(scoreController.text);
                    item.score[widget.weekIndex] =
                        int.parse(scoreController.text);
                  } else {
                    item.sm[widget.week] = int.parse(scoreController.text);
                    item.scoreQ[widget.weekIndex] =
                        int.parse(scoreController.text);
                  }

                  model.update(item.id, item);
                  model.fetch();
                },
                child: new Text('Sure'),
              ),
            ],
          );
        });
  }

  void _hq(int type, Student item, StudentModel model,int scheme) {
    int num = 0;
    if (type == 0) {
      if (item.qm.containsKey(widget.week)) {
        num = item.qm[widget.week].toInt();
      }
    } else {
      if (item.sm.containsKey(widget.week)) {
        num = item.sm[widget.week].toInt();
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        var hd = HDDialog(
          numTemp: num,scheme:scheme
        );
        return CupertinoAlertDialog(
          title: Text('HD Level'),
          content: Material(
            color: Colors.white10,
            child: hd,
          ),
          actions: <Widget>[
            new CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop('Cancel');
              },
              child: new Text('Cancel'),
            ),
            new CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop('Accept');
                Fluttertoast.showToast(msg: '${hd.numTemp}');

                if (type == 0) {
                  item.qm[widget.week] = hd.numTemp;
                  item.score[widget.weekIndex] = 100 - num * 10;
                } else {
                  item.sm[widget.week] = hd.numTemp;
                  item.scoreQ[widget.weekIndex] = 100 - num * 10;
                }

                model.update(item.id, item);
                model.fetch();
              },
              child: new Text('Sure'),
            ),
          ],
        );
      },
    );
  }

}

class MulDialog extends StatefulWidget {
  final List<dynamic> checkList;

  MulDialog({Key key, this.checkList}) : super(key: key);

  @override
  _MulDialogState createState() => _MulDialogState();
}

class _MulDialogState extends State<MulDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: multipleC.asMap().keys.map((index) {
        return Row(
          children: [
            Checkbox(
                value: widget.checkList[index],
                onChanged: (b) {
                  setState(() {
                    widget.checkList[index] = b;
                  });
                }),
            Text(multipleC[index]),
          ],
        );
      }).toList(),
    );
  }
}

// ignore: must_be_immutable
class HDDialog extends StatefulWidget {
  int numTemp;
  int scheme;

  HDDialog({Key key, this.numTemp, this.scheme}) : super(key: key);

  @override
  _HDDialogState createState() => _HDDialogState();
}

class _HDDialogState extends State<HDDialog> {
  @override
  Widget build(BuildContext context) {
    Map map = widget.scheme == 0 ? hdLevel.asMap() : abcLevel.asMap();
    return Column(
      children: map.keys.map((index) {
        return Row(
          children: [
            Radio(
              value: index == widget.numTemp,
              onChanged: (value) {
                setState(() {
                  widget.numTemp = index;
                });
              },
              groupValue: true,
            ),
            Text(widget.scheme == 0 ? hdLevel[index] : abcLevel[index]),
          ],
        );
      }).toList(),
    );
  }
}
