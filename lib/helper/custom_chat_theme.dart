import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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

  static LinearGradient customTheme(String type, int index) {
    if (type == "sender") {
      return msgThemeGradient[index];
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

  static LinearGradient customChatBGTheme(
      int choosenindex, BuildContext context) {
    if (choosenindex == 0) {
      if (Get.isDarkMode) {
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 48, 48, 48),
            Color.fromARGB(255, 75, 75, 75),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      } else {
        return chatThemeGradient[choosenindex];
      }
    } else {
      return chatThemeGradient[choosenindex];
    }
  }

  // App themes
  static ThemeData lighttheme = ThemeData(
    appBarTheme: const AppBarTheme(centerTitle: true),
    brightness: Brightness.light,
    primaryColor: const Color(0xFF4B39EF),
    primaryColorLight: const Color.fromARGB(255, 255, 255, 255),
    primaryColorDark:
        const Color.fromARGB(255, 0, 0, 0), //to be dybnamically changed
    textTheme: GoogleFonts.outfitTextTheme(), useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(centerTitle: true),
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF4B39EF),
    primaryColorLight: const Color.fromARGB(255, 0, 0, 0),
    primaryColorDark:
        const Color.fromARGB(255, 255, 255, 255), //to be dybnamically changed
    textTheme: GoogleFonts.outfitTextTheme(), useMaterial3: true,
  );

  // Linear Gradient List
  static List<LinearGradient> chatThemeGradient = [
    // Default
    const LinearGradient(
      colors: [
        Color.fromARGB(255, 255, 255, 255),
        Color.fromARGB(255, 255, 255, 255),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    // Blue
    const LinearGradient(
      colors: [
        Color.fromARGB(255, 81, 211, 228),
        Color.fromARGB(255, 33, 150, 243),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    // Red
    const LinearGradient(
      colors: [
        Color.fromARGB(255, 255, 107, 96),
        Color.fromARGB(255, 252, 175, 60),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    //  green
    const LinearGradient(
      colors: [
        Color.fromARGB(255, 107, 207, 110),
        Color.fromARGB(255, 36, 200, 184),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    //Purple
    const LinearGradient(
      colors: [
        Color.fromARGB(255, 33, 150, 243),
        Color.fromARGB(255, 156, 39, 176),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];

  // Linear Gradient List
  static List<LinearGradient> msgThemeGradient = [
    // Default
    const LinearGradient(
      colors: [
        Color.fromARGB(255, 0, 126, 239),
        Color.fromARGB(255, 0, 124, 236),
        Color.fromARGB(255, 0, 115, 218),
        Color.fromARGB(255, 5, 109, 208),
        Color.fromARGB(255, 22, 102, 193),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [
        Color.fromARGB(255, 225, 90, 90),
        Color.fromARGB(255, 252, 96, 96),
        Color.fromARGB(255, 250, 85, 85),
        Color.fromARGB(255, 255, 69, 69),
        Color.fromARGB(255, 218, 32, 32),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [
        Color.fromARGB(255, 157, 0, 188),
        Color.fromARGB(255, 167, 0, 200),
        Color.fromARGB(255, 139, 0, 185),
        Color.fromARGB(255, 129, 7, 156),
        Color.fromARGB(255, 98, 20, 146),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [
        Color.fromARGB(255, 63, 181, 0),
        Color.fromARGB(255, 54, 154, 0),
        Color.fromARGB(255, 45, 142, 4),
        Color.fromARGB(255, 21, 141, 21),
        Color.fromARGB(255, 22, 121, 11),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [
        Color.fromARGB(255, 227, 136, 0),
        Color.fromARGB(255, 223, 152, 12),
        Color.fromARGB(255, 221, 154, 9),
        Color.fromARGB(255, 222, 147, 7),
        Color.fromARGB(255, 163, 121, 6),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];
}
