import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

/// The class with the scaffold
class MyAppState extends State<MyApp> {
  final _pickedImages = <Image>[];
  final _pickedVideos = <dynamic>[];

  String _imageInfo = '';
  File? _image;
  final picker = ImagePicker();
  final pickerWeb = ImagePickerWeb();

  Future getImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File rotatedImage =
          await FlutterExifRotation.rotateImage(path: image.path);

      setState(() {
        _image = rotatedImage;
      });
    }
  }

  Future getImageAndSave() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File rotatedImage =
          await FlutterExifRotation.rotateAndSaveImage(path: image.path);

      setState(() {
        _image = rotatedImage;
      });
    }
  }

  Future takePicture() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      File rotatedImage =
          await FlutterExifRotation.rotateAndSaveImage(path: image.path);

      setState(() {
        _image = rotatedImage;
      });
    }
  }

  Future takePictureWeb() async {
    final fromPicker = await ImagePickerWeb.getImageAsWidget();
    if (fromPicker != null) {
      setState(() {
        _pickedImages.clear();
        _pickedImages.add(fromPicker);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exif flutter rotation image example app'),
        ),
        body: Center(
          child: _image == null
              ? const Text('No image selected.')
              : Image.file(_image!),
        ),
        persistentFooterButtons: <Widget>[
          FloatingActionButton(
            onPressed: getImageAndSave,
            tooltip: 'Pick Image and save',
            child: const Icon(Icons.save),
          ),
          FloatingActionButton(
            onPressed: getImage,
            tooltip: 'Pick Image without saving',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: takePicture,
            tooltip: 'Pick Image without saving',
            child: const Icon(Icons.camera_alt),
          ),
          FloatingActionButton(
            onPressed: takePictureWeb,
            tooltip: 'Pick Image without saving',
            child: const Icon(Icons.web),
          ),
        ],
      ),
    );
  }
}
