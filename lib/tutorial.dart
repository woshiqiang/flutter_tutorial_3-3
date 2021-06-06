import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Tutorial {
  String id;
  String sid;
  String name;
  List<dynamic> score;
  List<int> scoreQ;
  Map<String, Object> qm = HashMap();
  Map<String, Object> sm = HashMap();

  Tutorial({this.id,this.sid, this.name, this.score, this.scoreQ});

  Tutorial.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        sid = json['sid'],
        name = json['name'],
        score = json['score'],
        qm = json['qm'],
        sm = json['sm'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'sid': sid,
        'name': name,
        'score': score,
        'scoreQ': scoreQ,
        'qm': qm,
        'sm': sm
      };
}

class TutorialModel extends ChangeNotifier {
  final List<Tutorial> items = [];

  CollectionReference tutorialsCollection =
      FirebaseFirestore.instance.collection('tutorials');

  //added this
  bool loading = false;

  TutorialModel() {
    fetch();
  }


  void add(Tutorial item) async {
    notifyListeners();

    await tutorialsCollection.add(item.toJson());

    await fetch();
  }

  void delete(String id) async {
    loading = true;
    notifyListeners();

    await tutorialsCollection.doc(id).delete();

    //refresh the db
    await fetch();
  }

  Tutorial get(String id) {
    if (id == null) return null;
    return items.firstWhere((item) => item.id == id);
  }

  void update(String id, Tutorial item) async {
    loading = true;
    notifyListeners();

    await tutorialsCollection.doc(id).set(item.toJson());

    //refresh the db
    await fetch();
  }

  void fetch() async {
    items.clear();

    //indicate that we are loading
    loading = true;
    notifyListeners(); //tell children to redraw, and they will see that the loading indicator is on

    //get all students
    var querySnapshot = await tutorialsCollection.orderBy("name").get();

    //iterate over the students and add them to the list
    querySnapshot.docs.forEach((doc) {
      //note not using the add(Movie item) function, because we don't want to add them to the db
      var item = Tutorial.fromJson(doc.data());
      item.id = doc.id; //add this line
      items.add(item);
    });

    //put this line in to artificially increase the load time, so we can see the loading indicator (when we add it in a few steps time)
    //comment this out when the delay becomes annoying
//    await Future.delayed(Duration(seconds: 1));

    //we're done, no longer loading
    loading = false;
    notifyListeners();
  }
}
