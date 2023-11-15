import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:windchat/api/api.dart';
import 'package:windchat/helper/dialogs.dart';
import 'package:windchat/main.dart';
import 'package:windchat/screens/homescreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _handleGoogleButtonClick() {
    // To show the Progress bar
    Dialogs.showProgressBar(context);

    _signInWithGoogle().then((user) async {
      // To Hide the progress bar
      Navigator.pop(context);

      if (user != null) {
        if (await API.userExists()) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else {
          await API.createUser().then((value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen())));
        }
      }
    });
  }

// Federated identity & social sign-in

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      // If internet is Unavailable
      await InternetAddress.lookup('google.com');

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log('\nsignInWithGoogle : $e');
      // ignore: use_build_context_synchronously
      Dialogs.showSnackBar(
          context, 'No Internet, Please try later.', Colors.black);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            width: 500,
            child: Image.asset("assets/images/d3.png"),
          ),
          Positioned(
            top: mq.height * .6,
            child: Image.asset(
              "assets/images/google.png",
              height: mq.height * .08,
            ),
          ),
          Positioned(
              top: mq.height * .72,
              width: mq.width * .7,
              height: mq.height * .06,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                    backgroundColor: const Color(0xFF4B39EF),
                    side: const BorderSide(color: Color(0xFF4B39EF)),
                  ),
                  onPressed: () {
                    _handleGoogleButtonClick();
                  },
                  child: const Text(
                    "Login with Google",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ))),
          Positioned(
              bottom: mq.height * .05,
              child: Text(
                "Share your smile with this world and find friends",
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 16,
                ),
              )),
        ],
      ),
    );
  }
}
