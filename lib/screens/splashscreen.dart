import 'dart:developer';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:windchat/main.dart';
import 'package:windchat/screens/auth/loginscreen.dart';
import 'package:windchat/screens/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    // for logo animation
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    // Start the rotation animation
    animationController.repeat();
    // Stop the rotation after 3 seconds
    Future.delayed(const Duration(seconds: 1), () {
      animationController.stop();
    });

    // Handle Login
    Future.delayed(const Duration(seconds: 3), () {
      if (FirebaseAuth.instance.currentUser != null) {
        // Check if the user is logged in
        log('User Already Logged In : ${FirebaseAuth.instance.currentUser!.email}');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        // if not logged in then go to LOGIN SCREEN
        log('Not Logged In : Moving to Login Screen');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mediaquery - Get the screen size of the device
    mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: mq.height * .35,
              child: AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget? child) {
                  return Transform.rotate(
                    angle: animationController.value * 100,
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: 170,
                    ),
                  );
                },
              )),
          Positioned(
            top: mq.height * .87,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Wind',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'Chat',
                      textStyle: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                      colors: [
                        Colors.purple,
                        Colors.blue,
                        Colors.yellow,
                        Colors.red,
                        Colors.white,
                      ],
                      speed: const Duration(milliseconds: 300),
                    ),
                  ],
                  totalRepeatCount: 2,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: mq.height * .04,
            child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'Made with ❤️',
                  textStyle: const TextStyle(
                    fontSize: 15,
                  ),
                  speed: const Duration(milliseconds: 70),
                ),
              ],
              totalRepeatCount: 1,
            ),
          )
        ],
      ),
    );
  }
}
