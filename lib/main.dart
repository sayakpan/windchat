import 'dart:developer';

import 'package:fcm_channels_manager/fcm_channels_manager.dart';
import 'package:flutter/material.dart';
import 'package:windchat/screens/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  await _initializeNotificationChannel();
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

// Notification Channel Initialization

Future<void> _initializeNotificationChannel() async {
  // var result = await FlutterNotificationChannel.registerNotificationChannel(
  //   description: 'Message Notification for chats',
  //   id: 'chats',
  //   importance: NotificationImportance.IMPORTANCE_HIGH,
  //   name: 'Chats',
  // );
  final result = await FcmChannelsManager().registerChannel(
    id: "chats",
    name: "Chats",
    description: "Receive new feedback and system's notification",
    importance: NotificationImportance.importanceHight,
    visibility: NotificationVisibility.public,
    bubbles: true,
    vibration: true,
    sound: true,
    badge: true,
  );
  log(result!);
  final channesl = await FcmChannelsManager().getChannels();
  for (var element in channesl) {
    log(element.id);
  }
}
