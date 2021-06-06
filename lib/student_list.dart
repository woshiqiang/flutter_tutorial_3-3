import 'package:flutter/material.dart';
import 'package:flutter_tutorial_3/student.dart';
import 'package:flutter_tutorial_3/student_details.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
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
                  home: MyHomePage(title: 'Student List')));
          //END: the old MyApp builder from last week
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return FullScreenText(text: "Loading");
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StudentModel>(builder: buildScaffold);
  }

  Scaffold buildScaffold(BuildContext context, StudentModel studentModel, _) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
       /* leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),*/
      ),

      //added this
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                return StudentDetails();
              }));
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //YOUR UI HERE
            if (studentModel.loading)
              CircularProgressIndicator()
            else
              Expanded(
                child: ListView.builder(
                    itemBuilder: (_, index) {
                      var student = studentModel.items[index];
                      return Dismissible(
                        child: ListTile(
                          title: Text(student.name),
                          subtitle: Text(
                            student.email + " - " + student.course.toString(),
                          ),
                          leading: null,
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return StudentDetails(id: student.id);
                            }));
                          },
                        ),
                        background: Container(
                          color: Colors.green,
                        ),
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          setState(() {
                            studentModel.delete(student.id);
                          });
                        },
                      );
                    },
                    itemCount: studentModel.items.length),
              )
          ],
        ),
      ),
    );
  }
}

//A little helper widget to avoid runtime errors -- we can't just display a Text() by itself if not inside a MaterialApp, so this workaround does the job
class FullScreenText extends StatelessWidget {
  final String text;

  const FullScreenText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Column(children: [Expanded(child: Center(child: Text(text)))]));
  }
}
