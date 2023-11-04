import 'package:flutter/widgets.dart';

class CustomTheme {
  static LinearGradient defaultTheme(String type) {
    if (type == "sender") {
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 122, 110, 234),
          Color.fromARGB(255, 69, 54, 207),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 255, 255, 255),
          Color.fromARGB(255, 235, 235, 235),
          Color.fromARGB(255, 208, 208, 208)
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  static LinearGradient customTheme(String type) {
    if (type == "sender") {
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 0, 126, 239),
          Color.fromARGB(255, 0, 124, 236),
          Color.fromARGB(255, 0, 115, 218),
          Color.fromARGB(255, 5, 109, 208),
          Color.fromARGB(255, 22, 102, 193),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
    } else {
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 227, 233, 249),
          Color.fromARGB(255, 227, 233, 249),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  static LinearGradient defaultChatBGTheme() {
    return const LinearGradient(
      colors: [
        Color.fromARGB(255, 168, 241, 246),
        Color.fromARGB(255, 244, 246, 206),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient customChatBGTheme() {
    return const LinearGradient(
      colors: [
        Color.fromARGB(255, 255, 255, 255),
        Color.fromARGB(255, 255, 255, 255),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
