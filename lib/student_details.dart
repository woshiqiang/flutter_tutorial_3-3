import 'package:flutter/material.dart';
import 'package:flutter_tutorial_3/student.dart';
import 'package:provider/provider.dart';

/// add or edit student
class StudentDetails extends StatefulWidget {
  final String id; //this is an id now
  const StudentDetails({Key key, this.id}) : super(key: key);

  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final courseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var student = Provider.of<StudentModel>(context, listen:false).get(widget.id);
    var adding = student == null;
    if (!adding) {
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
                  if (adding == false) Text("Student Index ${widget.id}"), //check out this dart syntax, lets us do an if as part of an argument list
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
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
                              }

                              //update the student object
                              student.name = nameController.text;
                              student.email = emailController.text; //good code would validate these
                              student.course = courseController.text; //good code would validate these

                              //TODO: update the model
                              if (adding)
                                Provider.of<StudentModel>(context, listen:false).add(student);
                              else
                                Provider.of<StudentModel>(context, listen:false).update(widget.id, student);

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
