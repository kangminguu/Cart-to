import 'package:capstone_project/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

late List<CameraDescription> _cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // home: StartedContentScreen(),
      home: HomeScreen(),
    );
  }
}

class ProvideCamera extends ChangeNotifier {
  List<CameraDescription> get cameras => _cameras;
}
