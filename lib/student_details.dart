import 'package:flutter/material.dart';
import 'package:flutter_tutorial_3/student.dart';
import 'package:flutter_tutorial_3/tutorial.dart';
import 'package:provider/provider.dart';

/// add or edit student
class StudentDetails extends StatefulWidget {
//  final String id; //this is an id now
  final Student student;
  const StudentDetails({Key key, this.student}) : super(key: key);

  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  final _formKey = GlobalKey<FormState>();
  final sidController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final courseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
//    var student = Provider.of<StudentModel>(context, listen:false).get(widget.id);
    var student = widget.student;
    var adding = student == null;
    if (!adding) {
      sidController.text = student.sid;
      nameController.text = student.name;
      emailController.text = student.email;
      courseController.text = student.course;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(adding ? "Add Student" : "Edit Student"),
        ),
        body: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if (adding == false) Text("Student Index ${student.id}"), //check out this dart syntax, lets us do an if as part of an argument list
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: "sid"),
                            controller: sidController,
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: "name"),
                            controller: nameController,
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: "email"),
                            controller: emailController,
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: "course"),
                            controller: courseController,
                          ),
                          ElevatedButton.icon(onPressed: () {
                            if (_formKey.currentState.validate())
                            {
                              if (adding)
                              {
                                student = Student();
                                student.id = sidController.text;
                              }

                              //update the student object
                              student.sid = sidController.text;
                              student.name = nameController.text;
                              student.email = emailController.text; //good code would validate these
                              student.course = courseController.text; //good code would validate these

                              //TODO: update the model
                              if (adding) {
                                Provider.of<StudentModel>(
                                    context, listen: false).add(student);
                                var tutorial = Tutorial(id: student.sid,sid: student.sid,name: student.name);
                                tutorial.scoreQ = [0,0,0,0,0,0,0,0,0,0,0,0];
                                tutorial.score = [0,0,0,0,0,0,0,0,0,0,0,0];
                                var tutorialModel = TutorialModel();
                                tutorialModel.add(tutorial);
                              }else
                                Provider.of<StudentModel>(context, listen:false).update(student.id, student);

                              //return to previous screen
                              Navigator.pop(context);
                            }
                          }, icon: Icon(Icons.save), label: Text("Save Values"))
                        ],
                      ),
                    ),
                  )
                ]
            )
        )
    );
  }
}
