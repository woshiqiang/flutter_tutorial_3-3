import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial_3/student.dart';
import 'package:flutter_tutorial_3/student_score.dart';
import 'package:image_picker/image_picker.dart';

class StudentInfo extends StatefulWidget {
  final Student student;

  const StudentInfo({
    Key key,
    this.student,
  }) : super(key: key);

  @override
  _StudentInfoState createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  File file;
  String downLoadUrl;



  @override
  void initState() {
    super.initState();
    try{
      getImage();
    }catch(e){
    }
  }

  void getImage() async {
    var url = await FirebaseStorage.instance
        .ref('uploads/' + widget.student.id + '.jpeg')
        .getDownloadURL();
    setState(() {
      downLoadUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Information'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Student Information',
              style: TextStyle(
                fontSize: 30,
                color: Colors.blue,
              ),
            ),
            InkWell(
              child: downLoadUrl != null
                  ? Image.network(
                      downLoadUrl,
                      height: 120,
                    )
                  : (file != null
                      ? Image.file(
                          file,
                          height: 120,
                        )
                      : Image.asset(
                          "assets/avatar_foreground.png",
                          fit: BoxFit.cover,
                        )),
              onTap: () {
                showDialog<Null>(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text('SELECT HEAD'),
                      children: <Widget>[
                        SimpleDialogOption(
                          child: ElevatedButton(
                            onPressed: () async  {
                              Navigator.of(context).pop();
                              androidIOSUpload();
                            },
                            child: Text('TAKE PICTURE'),
                          ),
                        ),
                        SimpleDialogOption(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              final picker = ImagePicker();
                              final pickedFile = await picker.getImage(
                                  source: ImageSource.gallery);
                              if (pickedFile != null) {
                                setState(() {
                                  file = File(pickedFile.path);
                                });
                                //now do the upload
                                try {
                                  await FirebaseStorage.instance
                                      .ref('uploads/' + widget.student.id + '.jpeg')
                                      .putFile(file);
                                  var url = await FirebaseStorage.instance
                                      .ref('uploads/' + widget.student.id + '.jpeg')
                                      .getDownloadURL();
                                  setState(() {
                                    downLoadUrl = url;
                                  });
                                  print(downLoadUrl);
                                } on FirebaseException {
                                  // e.g, e.code == 'canceled'
                                }
                              }
                            },
                            child: Text('GALLERY'),
                          ),
                        ),
                        SimpleDialogOption(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('CANCEL'),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Name:'),
                Text(widget.student.name),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('SID:'),
                Text(widget.student.sid),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Email:'),
                Text(widget.student.email),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Course:'),
                Text(widget.student.course),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text('student score'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return StudentScorePage(
                        student: widget.student,
                      );
                    }));
                  },
                ),
                SizedBox(
                  width: 40,
                ),
                ElevatedButton(
                  child: Text('remove'),
                  onPressed: () {
//                    StudentModel().delete(widget.student.id);
                    Navigator.pop(context, 1);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void androidIOSUpload() async {
    // 2. Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    //use the TakePictureScreen to get an image. This is like doing a startActivityForResult
    var picture = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(
                // Pass the appropriate camera to the TakePictureScreen widget.
                camera: firstCamera)));
    setState(() {
      file = picture;
    });
    //now do the upload
    try {
      await FirebaseStorage.instance
          .ref('uploads/' + widget.student.id + '.jpeg')
          .putFile(file);
      var downLoadUrl = await FirebaseStorage.instance
          .ref('uploads/' + widget.student.id + '.jpeg')
          .getDownloadURL();
      print(downLoadUrl);
    } on FirebaseException {
      // e.g, e.code == 'canceled'
    }
  }
}

//------------------------------------------
//camera example follows:
//------------------------------------------

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();
            final picture = File(image?.path);

            Navigator.pop(context, picture);
            return;
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}
