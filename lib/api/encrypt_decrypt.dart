import 'package:encrypt/encrypt.dart';
import 'package:windchat/main.dart';

// class EncryptDecrypt {
//   static final key = Key.fromUtf8('H7gK9sP2w5z8vByE3x6A1dC4fU0jL2qR');
//   static final iv = IV.fromLength(16);
//   static final encrypter = Encrypter(AES(key));

//   static String encryptAES(String plainText) {
//     final encrypted = encrypter.encrypt(plainText, iv: iv);
//     return encrypted.base64;
//   }

//   static String decryptAES(String encryptedbase64) {
//     final decrypted = encrypter.decrypt64(encryptedbase64, iv: iv);
//     return decrypted;
//   }
// }

class EncryptDecrypt {
  static final key = Key.fromUtf8('H7gK9sP2w5z8vByE3x6A1dC4fU0jL2qR');
  static final encrypter = Encrypter(AES(key));

  static String encryptAES(String plainText) {
    final iv = IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return "${iv.base64}:${encrypted.base64}"; // Include IV in the result
  }

  static String decryptAES(String encryptedData) {
    final parts = encryptedData.split(':');
    final iv = IV.fromBase64(parts[0]);
    final encryptedbase64 = parts[1];

    try {
      final decrypted = encrypter.decrypt64(encryptedbase64, iv: iv);
      return decrypted;
    } catch (error) {
      logger.e("Decryption error: $error");
      return ''; // Return an empty string or handle the error accordingly
    }
  }
}
