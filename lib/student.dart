import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Student {
  String id;
  String sid;
  String name;
  String email;
  String course;

  Student({this.sid, this.name, this.email, this.course});

  Student.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        sid = json['sid'],
        name = json['name'],
        email = json['email'],
        course = json['course'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'sid': sid, 'name': name, 'email': email, 'course': course};
}

class StudentModel extends ChangeNotifier {
  /// Internal, private state of the list.
  final List<Student> items = [];

  //added this
  CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection('students');

  //added this
  bool loading = false;

  Student get(String id) {
    if (id == null) return null;
    return items.firstWhere((student) => student.id == id);
  }

  void add(Student item) async {
    loading = true;
    notifyListeners();

    await studentsCollection.add(item.toJson());

    //refresh the db
    await fetch();
  }

  void update(String id, Student item) async {
    loading = true;
    notifyListeners();

    await studentsCollection.doc(id).set(item.toJson());

    //refresh the db
    await fetch();
  }

  void delete(String id) async {
    loading = true;
    notifyListeners();

    await studentsCollection.doc(id).delete();

    //refresh the db
    await fetch();
  }

  Future<Student> search(String key) async {
    //get all students
    var querySnapshot = await studentsCollection.orderBy("name").get();
    Student student = Student();
    //iterate over the students and add them to the list
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      var s = Student.fromJson(querySnapshot.docs[i].data());
      if (s.sid.contains(key) || s.name.contains(key)) {
        student = s;
        break;
      }
    }
    return student;
  }

  //replaced this
  StudentModel() {
    fetch();
  }

  void fetch() async {
    //clear any existing data we have gotten previously, to avoid duplicate data
    items.clear();

    //indicate that we are loading
    loading = true;
    notifyListeners(); //tell children to redraw, and they will see that the loading indicator is on

    //get all students
    var querySnapshot = await studentsCollection.orderBy("name").get();

    //iterate over the students and add them to the list
    querySnapshot.docs.forEach((doc) {
      //note not using the add(Movie item) function, because we don't want to add them to the db
      var student = Student.fromJson(doc.data());
      student.id = doc.id; //add this line
      items.add(student);
    });

    //put this line in to artificially increase the load time, so we can see the loading indicator (when we add it in a few steps time)
    //comment this out when the delay becomes annoying
//    await Future.delayed(Duration(seconds: 1));

    //we're done, no longer loading
    loading = false;
    notifyListeners();
  }
}
