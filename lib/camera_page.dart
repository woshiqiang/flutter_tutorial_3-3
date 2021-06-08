import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;

class CameraPage extends StatefulWidget {

  CameraPage(){
  }

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> cameras;
  CameraController controller;


 @override
  void initState() {
//   cameras = await availableCameras();
   controller = CameraController(cameras[0], ResolutionPreset.max);
   controller.initialize().then((_) {
     if (!mounted) {
       return;
     }
     setState(() {});
   });

   @override
   void dispose() {
     controller?.dispose();
     super.dispose();
   }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: CameraPreview(controller),
    );
  }
}
