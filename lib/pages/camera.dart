import 'dart:io';

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

  @override
  void initState() {
    super.initState();
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
        color: const Color.fromARGB(255, 207, 202, 202),
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
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          _buildCameraPreview(cameraController),
          Padding(
            padding: const EdgeInsets.only(top: 196),
            child: Column(
              children: [
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 96),
                    GestureDetector(
                      onTap: tirarFoto,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF666666).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(33),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    if (cameras.length > 1)
                      IconButton(
                        icon: Icon(
                          Icons.cameraswitch,
                          color: const Color(0xFF666666).withOpacity(0.4),
                          size: 30,
                        ),
                        onPressed: () {},
                      )
                    else
                      const SizedBox(width: 66),
                  ],
                ),
              ],
            ),
          ),

          // #  CASE STUDIES FOR TESTS # //

          // SizedBox(
          //   height: 600,
          //   child: Transform.scale(
          //     scale: 0.6,
          //     child: CameraPreview(controller!),
          //   ),
          // ),

          // Transform.rotate(
          //   angle: 190.07,
          //   child: CameraPreview(controller!),
          // ),

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
        ],
      );
    }
  }

  Widget _buildCameraPreview(CameraController cameraController) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Transform.scale(
        scale: 0.8,
        child: Center(
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0
                  //widget.isSelfie == true ? 1000 : 0,
                  ),
            ),
            child: AspectRatio(
              aspectRatio: 1 / 1.6,
              child: CameraPreview(cameraController),
            ),
          ),
        ),
      ),
    );
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
