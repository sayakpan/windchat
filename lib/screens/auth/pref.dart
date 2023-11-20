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

  static bool get isOnlineEnabled => _box.get('isOnlineEnabled') ?? true;
  static set isOnlineEnabled(bool value) => _box.put('isOnlineEnabled', value);

  static bool get isMoodEnabled => _box.get('isMoodEnabled') ?? false;
  static set isMoodEnabled(bool value) => _box.put('isMoodEnabled', value);

  static int get gradientIndex => _box.get('gradientIndex') ?? 0;
  static set gradientIndex(int value) => _box.put('gradientIndex', value);

  static int get gradientIndexForMsg => _box.get('gradientIndexForMsg') ?? 0;
  static set gradientIndexForMsg(int value) =>
      _box.put('gradientIndexForMsg', value);
}
