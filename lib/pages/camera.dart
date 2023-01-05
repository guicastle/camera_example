import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  XFile? imagem;
  Size? size;

  // List<DeviceOrientation> listOrientations = [
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp
  // ];

  @override
  void initState() {
    super.initState();
    // SystemChrome.setPreferredOrientations(listOrientations);
    _loadCameras();
  }

  _loadCameras() async {
    try {
      cameras = await availableCameras();
      _startCamera();
    } on Exception catch (e) {
      print(e);
    }
  }

  _startCamera() {
    if (cameras.isEmpty) {
      debugPrint('Câmera não foi encontrada');
    } else {
      _previewCamera(cameras.first);
    }
  }

  _previewCamera(CameraDescription camera) async {
    final CameraController cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    controller = cameraController;

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      debugPrint(e.description);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documento Oficial'),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[900],
        child: Center(
          child: SizedBox(
              width: size!.width - 50,
              height: size!.height - (size!.height / 3),
              child: imagem == null
                  ? _cameraPreviewWidget()
                  : _showImagePreviewWidget()),
        ),
      ),
      floatingActionButton: (imagem != null)
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.pop(context),
              label: const Text('Finalizar'),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _showImagePreviewWidget() {
    if (kIsWeb) {
      return Image.network(
        imagem!.path,
      );
    }

    return Image.file(
      File(imagem!.path),
      fit: BoxFit.contain,
    );
  }

  _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text('Widget para Câmera que não está disponível');
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.rotate(
            angle: 190.07,
            child: CameraPreview(controller!),
          ),

          // Empurra o widget pra fora ta tela DIMENSÃO X e DIMENSÃO Y
          // Transform.translate(
          //   offset: const Offset(150, 150),
          //   child: CameraPreview(controller!),
          // ),

          // Plano cartesiano afundando o widget pra dentro
          // Transform(
          //   transform: Matrix4.skewX(0.3),
          //   child: CameraPreview(controller!),
          // ),

          // Plano diagonal 3 dimensões
          // Transform(
          //   transform: Matrix4.diagonal3Values(0.9, 1.6, 1.8),
          //   child: CameraPreview(controller!),
          // ),

          // Transform(
          //   transform: Matrix4.identity()
          //     ..setEntry(3, 2, 0.01)
          //     ..rotateX(0),
          //   alignment: FractionalOffset.center,
          //   child: CameraPreview(controller!),
          // ),

          // Transform(
          //   transform: Matrix4.skewY(0.3)..rotateY(-pi / 12.0),
          //   alignment: FractionalOffset.center,
          //   child: CameraPreview(controller!),
          // ),

          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black.withOpacity(0.5),
            child: IconButton(
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 24,
              ),
              onPressed: tirarFoto,
            ),
          ),
        ],
      );
    }
  }

  tirarFoto() async {
    final CameraController? cameraController = controller;

    if (cameraController != null && cameraController.value.isInitialized) {
      try {
        XFile file = await cameraController.takePicture();
        if (mounted) setState(() => imagem = file);
      } on CameraException catch (e) {
        debugPrint(e.description);
      }
    }
  }
}
