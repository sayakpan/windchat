import 'dart:developer';
import 'package:fcm_channels_manager/fcm_channels_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:logger/logger.dart';
import 'package:windchat/helper/custom_chat_theme.dart';
import 'package:windchat/screens/auth/pref.dart';
import 'package:windchat/screens/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Pref.initializeHive();
  await _initializeFirebase();
  await _initializeNotificationChannel();
  runApp(const MyApp());
}

late Size mq;
var logger = Logger();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'WindChat',
        debugShowCheckedModeBanner: false,

        // Light and Dark Theme
        themeMode: Pref.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: CustomTheme.lighttheme,
        darkTheme: CustomTheme.darkTheme,
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
  log("_initializeNotificationChannel() : ${result!}");
  final channesl = await FcmChannelsManager().getChannels();
  for (var element in channesl) {
    log("_initializeNotificationChannel() : ${element.id}");
  }
}
