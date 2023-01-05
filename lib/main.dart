import 'package:flutter/material.dart';

import 'pages/camera.dart';
import 'pages/camera_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const CameraPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.center,
                child: const Text(
                  'body',
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(38.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          //Camera ANDROID e iOS
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CameraPage(),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        child: const Icon(Icons.camera),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          //Camera WEB
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CameraWebPage(),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        child: const Icon(Icons.web_asset),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          //Camera Face detector
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CameraWebPage(),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        child: const Icon(Icons.face_retouching_natural),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
