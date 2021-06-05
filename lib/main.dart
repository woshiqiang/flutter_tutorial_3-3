import 'package:flutter/material.dart';
import 'package:flutter_tutorial_3/movie_details.kt.dart';
import 'package:flutter_tutorial_3/student_add.dart';
import 'package:flutter_tutorial_3/student_info.dart';
import 'package:flutter_tutorial_3/student_list.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'movie.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
//  runApp(StudentListPage());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context,
              snapshot) //this functio is called every time the "future" updates
          {
        // Check for errors
        if (snapshot.hasError) {
          return FullScreenText(text: "Something went wrong");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          //BEGIN: the old MyApp builder from last week
          return ChangeNotifierProvider(
              create: (context) => MovieModel(),
              child: MaterialApp(
                  title: 'Student List',
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  home: MaterialApp(
                    title: 'aStudent',
                    home: Scaffold(
                      appBar: AppBar(
                        title: Text('aStudent'),
                      ),
                      body: MyHomePage(),
                    ),
                  )));
          //END: the old MyApp builder from last week
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return FullScreenText(text: "Loading");
      },
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
    Widget _a = Column(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return StudentAddPage();
                }));
              },
              child: Image.asset(
                "assets/ic_person_add.png",
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tap ID/Name(student infor/Score)',
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return StudentInfo();
                  }));
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: Center(
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
                        style: TextStyle(color: Colors.black),
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
                        style: TextStyle(color: Colors.black),
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
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return StudentListPage();
                      }));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    return _a;
  }
}
