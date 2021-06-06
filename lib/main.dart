import 'package:flutter/material.dart';
import 'package:flutter_tutorial_3/marking_page.dart';
import 'package:flutter_tutorial_3/student.dart';
import 'package:flutter_tutorial_3/student_details.dart';
import 'package:flutter_tutorial_3/student_info.dart';
import 'package:flutter_tutorial_3/student_list.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
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
              create: (context) => StudentModel(),
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
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget _a = Column(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return StudentDetails();
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
                controller: searchController,
              ),
            ),
            InkWell(
              onTap: () {},
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  //search
                  var key = searchController.text;
                  if (key.isEmpty) {
                    return;
                  }

                  var studentModel =
                      Provider.of<StudentModel>(context, listen: false);
                  studentModel.search(key).then((student) {
                    if (student.id == null) {
                      Fluttertoast.showToast(msg: 'Not find');
                      return;
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return StudentInfo();
                    }));
                  });
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
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 10.0,
                padding: EdgeInsets.all(4.0),
                children: <Widget>[
                 /* Column(
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
                  ),*/
                 InkWell(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Image.asset(
                         "assets/tutorial_work_foreground.png",
                         fit: BoxFit.cover,
                       ),
                       Text(
                         'Marking',
                         style: TextStyle(color: Colors.black),
                       )
                     ],
                   ),
                   onTap: (){
                     Navigator.push(context,
                         MaterialPageRoute(builder: (context) {
                           return MarkingPage();
                         }));
                   },
                 )
                  ,
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
