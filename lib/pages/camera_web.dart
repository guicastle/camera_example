import 'dart:io';
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraWebPage extends StatefulWidget {
  const CameraWebPage({super.key});

  @override
  State<CameraWebPage> createState() => _CameraWebPageState();
}

class _CameraWebPageState extends State<CameraWebPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  List<CameraDescription> cameras = [];
  CameraController? controller;
  XFile? imagem;
  CameraImage? imagem2;
  Size? size;

//TODO
//   ****O problema NÃO É orietation,
// o problema é quando está no celular o File
// arquivo final faça a rotação para retrato
  List<DeviceOrientation> listOrientations = [
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCamerasWeb();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _loadCamerasWeb() async {
    try {
      cameras = await availableCameras();
      _startCameraWeb();
    } on Exception catch (e) {
      print(e);
    }
  }

  _startCameraWeb() async {
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
      // await cameraController.onDeviceOrientationChanged([]); TODO Implementar pacode web no codigo

    } on CameraException catch (e) {
      debugPrint(e.description);
    }

    if (mounted) setState(() {});
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
                : Image.file(
                    File(imagem!.path),
                    fit: BoxFit.contain,
                  ),
          ),
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

  _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text('Widget para Câmera que não está disponível');
    } else {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          CameraPreview(controller!),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: tirarFoto,
              ),
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
