import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ImagePicker imagePicker;
  File _image;
  String result = '';
  ImageLabeler labeler;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    labeler = FirebaseVision.instance.imageLabeler();
  }

  _imgFromCamera() async {
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });

    doImageLabeling();
  }

  _imgFromGallery() async {
    PickedFile pickedFile =
        await imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
    doImageLabeling();
  }

  doImageLabeling() async {
    result = "";
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(_image);

    final List<ImageLabel> labels = await labeler.processImage(visionImage);

    for (ImageLabel li in labels) {
      result += li.text + " " + li.confidence.toStringAsFixed(2) + "\n";
    }

    setState(() {
      result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/img2.jpg'), fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              SizedBox(
                width: 100,
              ),
              Container(
                margin: EdgeInsets.only(top: 100),
                child: Stack(children: <Widget>[
                  Stack(children: <Widget>[
                    Center(
                      child: Image.asset(
                        'images/frame3.png',
                        height: 210,
                        width: 200,
                      ),
                    ),
                  ]),
                  Center(
                    child: TextButton(
                      onPressed: _imgFromGallery,
                      onLongPress: _imgFromCamera,
                      child: Container(
                        margin: EdgeInsets.only(top: 8),
                        child: _image != null
                            ? Image.file(
                                _image,
                                width: 135,
                                height: 195,
                                fit: BoxFit.fill,
                              )
                            : Container(
                                width: 140,
                                height: 150,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                    ),
                  ),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  '$result',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'finger_paint', fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
