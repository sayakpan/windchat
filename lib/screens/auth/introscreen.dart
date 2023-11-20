import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:windchat/screens/auth/loginscreen.dart';
import 'package:windchat/screens/auth/pref.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    var pageDecoration = PageDecoration(
      bodyTextStyle: TextStyle(color: Theme.of(context).primaryColorDark),
      titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColorDark),
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: const EdgeInsets.only(top: 100),
    );

    return IntroductionScreen(
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      infiniteAutoScroll: false,

      pages: [
        PageViewModel(
          title: "Only Gmail, No Number",
          body:
              "Sign in with your Gmail account to get started. No need to share your phone number. Enjoy hassle-free access to your conversations.",
          image: Pref.isDarkMode
              ? Image.asset("assets/images/pic1dark.png")
              : Image.asset("assets/images/pic1.png"),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Friend Requests",
          body:
              "Connect with friends seamlessly. Send and receive friend requests to start chatting. Grow your network and stay connected.",
          image: Pref.isDarkMode
              ? Image.asset("assets/images/pic2dark.png")
              : Image.asset("assets/images/pic2.png"),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Customized Chat Themes",
          body:
              "Personalize your chatting experience with customized chat themes. Choose from a variety of themes to match your style and mood.",
          image: Pref.isDarkMode
              ? Image.asset("assets/images/pic3dark.png")
              : Image.asset("assets/images/pic3.png"),
          decoration: pageDecoration,
        ),
      ],

      onDone: () => {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()))
      },
      onSkip: () => {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()))
      }, // You can override onSkip callback
      showSkipButton: true,
      showDoneButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Finish', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
