import 'dart:developer';
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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Handle Login
    Future.delayed(const Duration(seconds: 2), () {
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
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: mq.height * .25,
              child: Image.asset(
                "assets/images/logo.png",
                width: 200,
              )),
          Positioned(
              top: mq.height * .5,
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Wind',
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'Chat',
                      style: TextStyle(
                        fontSize: 50,
                        color: Theme.of(context)
                            .primaryColor, // Use the desired color
                      ),
                    ),
                  ],
                ),
              )),
          Positioned(
              bottom: mq.height * .04,
              child: const Text(
                "Made with ❤️",
                style: TextStyle(fontSize: 20),
              ))
        ],
      ),
    );
  }
}
