import 'package:flutter/material.dart';
import 'package:flutter_tutorial_3/student.dart';
import 'package:flutter_tutorial_3/student_details.dart';
import 'package:flutter_tutorial_3/tutorial.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

class MarkingPage extends StatefulWidget {
  @override
  _MarkingPageState createState() => _MarkingPageState();
}

class _MarkingPageState extends State<MarkingPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TutorialModel(),
      child: Consumer<TutorialModel>(builder: buildScaffold),
    );
  }

  Scaffold buildScaffold(BuildContext context, TutorialModel model, _) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marking'),
      ),
    );
  }
}
