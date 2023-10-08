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
          // Positioned(
          //   top: mq.height * .6,
          //   height: 50,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Navigator.pushReplacement(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const HomeScreen()));
          //     },
          //     style: ElevatedButton.styleFrom(
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(50),
          //         ),
          //         backgroundColor: Theme.of(context).primaryColor,
          //         foregroundColor: Colors.white,
          //         elevation: 3),
          //     child: const Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Text(
          //           'Get Started',
          //           style: TextStyle(fontSize: 20),
          //         ),
          //         SizedBox(width: 8),
          //         Icon(
          //           Icons.arrow_forward,
          //           size: 20,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
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


// body: Center(
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Image.asset(
//             'assets/images/logo.png',
//             width: 150,
//           ),
//           Padding(
//               padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
//               child: RichText(
//                 text: TextSpan(
//                   children: [
//                     const TextSpan(
//                       text: 'Wind',
//                       style: TextStyle(
//                         fontSize: 60,
//                         color: Colors.black,
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'Chat',
//                       style: TextStyle(
//                         fontSize: 60,
//                         color: Theme.of(context)
//                             .primaryColor, // Use the desired color
//                       ),
//                     ),
//                   ],
//                 ),
//               )),
//           Padding(
//             padding: const EdgeInsets.only(top: 40),
//             child: FilledButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const HomeScreen()),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Theme.of(context)
//                     .primaryColor, // Set the button's fill color
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 20, vertical: 15), // Adjust padding
//                 shape: RoundedRectangleBorder(
//                   borderRadius:
//                       BorderRadius.circular(30), // Set button's border radius
//                 ),
//               ),
//               child: const Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text('Get Started', style: TextStyle(fontSize: 18)),
//                   SizedBox(width: 8),
//                   Icon(Icons.arrow_forward, size: 20), // Add an arrow icon
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//               padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//               child: RichText(
//                 text: const TextSpan(
//                   children: [
//                     TextSpan(
//                       text: 'Made with ❤️',
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               )),
//         ]),
//       ),
