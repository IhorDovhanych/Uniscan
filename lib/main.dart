import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Uniscan/firebase_options.dart';
import 'package:Uniscan/pages/camera_page.dart';
import 'package:Uniscan/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'NAMU'),
        home: PageView(
          physics: const BouncingScrollPhysics(),
          controller: _pageController,
          children: List.unmodifiable([
            const HomePage(barcode: '',),
            CameraPage(pageController: _pageController)
          ]),
        ));
  }
}
