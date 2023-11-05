import 'package:hive_flutter/hive_flutter.dart';

class Pref {
  static late Box _box;
  // Initialize Hive for storing data
  static Future<void> initializeHive() async {
    await Hive.initFlutter();
    _box = await Hive.openBox("data");
  }

  //for storing theme data
  static bool get isDarkMode => _box.get('isDarkMode') ?? false;
  static set isDarkMode(bool value) => _box.put('isDarkMode', value);
}
