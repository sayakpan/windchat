import 'package:encrypt/encrypt.dart';

class EncryptDecrypt {
  static final key = Key.fromUtf8('H7gK9sP2w5z8vByE3x6A1dC4fU0jL2qR');
  static final iv = IV.fromLength(16);
  static final encrypter = Encrypter(AES(key));

  static String encryptAES(String plainText) {
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static String decryptAES(String encryptedbase64) {
    final decrypted = encrypter.decrypt64(encryptedbase64, iv: iv);
    return decrypted;
  }
}
