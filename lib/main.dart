import 'package:flutter/material.dart';
import 'package:windchat/screens/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  runApp(const MyApp());
}

late Size mq;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'WindChat',
        theme: ThemeData(
            textTheme: GoogleFonts.outfitTextTheme(),
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF4B39EF)),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(centerTitle: true)),
        home: const SplashScreen());
  }
}

// Firebase Initialization

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
