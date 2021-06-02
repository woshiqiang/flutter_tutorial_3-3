import 'package:flutter/material.dart';
import 'package:flutter_tutorial_3/movie_details.kt.dart';
import 'package:flutter_tutorial_3/student_list.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'movie.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
//  runApp(StuentListWidget());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'aStudent',
      home: Scaffold(
        appBar: AppBar(
          title: Text('aStudent'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        child: GridView.count(
          //列数
          crossAxisCount: 2,
          //水平间距
          crossAxisSpacing: 4.0,
          //垂直间距
          mainAxisSpacing: 10.0,
          padding: EdgeInsets.all(4.0),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/ic_main_attendance_records.png",
                  fit: BoxFit.cover,
                ),
                Text(
                  'Attendance records',
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/tutorial_work_foreground.png",
                  fit: BoxFit.cover,
                ),
                Text(
                  'Tutorial work',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/student_score_foreground.png",
                  fit: BoxFit.cover,
                ),
                Text(
                  'Student score',
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                )
              ],
            ),
            InkWell(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/student_list_foreground.png",
                    fit: BoxFit.cover,
                  ),
                  Text(
                    'Student list ',
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  )
                ],
              ),
              onTap: () {
                print("ddddd");
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return StuentListPage();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}
