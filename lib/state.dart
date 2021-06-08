import 'package:cloud_firestore/cloud_firestore.dart';

class StateInfo {
  String week;
  String mode;

  StateInfo({this.week, this.mode});

  StateInfo.fromJson(Map<String, dynamic> json)
      : week = json['week'],
        mode = json['mode'];

  Map<String, dynamic> toJson() => {'week': week, 'mode': mode};
}

class StateModel {
  CollectionReference stateCollection =
      FirebaseFirestore.instance.collection('state2');

  StateModel() {
    get('week1');
  }

  void add(StateInfo state) async {
    print('add data-------------------');
//    await stateCollection.firestore.collection(state.week).add(state.toJson());
//    await stateCollection.add(state.toJson());
    await stateCollection.doc(state.week).set(state.toJson());
//    get('week1');
  }

  void get(String week) async {
    /* var querySnapshot = await stateCollection.orderBy("week").get();
    querySnapshot.docs.forEach((doc) {
      print(doc.id);
      print(doc.data());
      stateCollection.doc(doc.id).delete();
    });*/
     /* stateCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc.id);
        print(doc.data());
//        doc.reference.delete().then((value) => (){
//          print('删除成功');
//        });
      });
    });*/

    stateCollection.doc('week1').get().then((DocumentSnapshot ds) {
      print(ds.id);
      print( ds.data());

    });
    /* stateCollection.doc(week).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });*/
  }
}
