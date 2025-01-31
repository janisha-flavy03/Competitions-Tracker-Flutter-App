import 'package:trophy_trail/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'controller/home_controller.dart'; // Ensure this is the correct path to your HomeController
import 'firebase_options.dart';           // Ensure this is the correct path to your Firebase configuration
import 'pages/home_page.dart';            // Update with the correct path to your HomePage

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: firebaseOptions);

  // Registering the HomeController using GetX
  Get.put(HomeController());

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TrophyTrail Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Initial route or main page
      home: WelcomePage(),
    );
  }
}
