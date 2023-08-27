import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:encrypt/encrypt.dart';

class EncryptHelper {
  final ivBytes = Uint8List.fromList([
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00
  ]);

  Uint8List generateKey(String password) {
    const utf8Encoder = Utf8Encoder();

    final bytes = utf8Encoder.convert(password);
    final digest = crypto.sha256.convert(Uint8List.fromList(bytes));

    final key = digest.bytes;

    // print('SHA-256 key: $key');

    return Uint8List.fromList(key);
  }

  String decryptSecretKey(String key, String decodeText) {
    Uint8List keyToDecrypt = generateKey(key);
    Uint8List decodeCipherText = base64Decode(decodeText);
    // debugPrint('base 64 decoded text : $decodeCipherText');

    final encrypter = Encrypter(
      AES(Key(keyToDecrypt), mode: AESMode.cbc, padding: 'PKCS7'),
    );

    final decrypted =
        encrypter.decrypt(Encrypted(decodeCipherText), iv: IV(ivBytes));

    print('decrypted text = $decrypted');
    return decrypted;
  }

  String encryptText(String text) {
    final decryptedSecretKey =
        decryptSecretKey(YXBpYW1pa29t.api_main, YXBpYW1pa29t.secret_key);

    print("key to ascii : ${decryptedSecretKey.toAscii()}");
    // var md = md5.convert(Utf8Encoder().convert(decryptedSecretKey.toAscii()));
    final md_5 = crypto.md5.convert(utf8.encode(decryptedSecretKey.toAscii()));
    final digestOfPassword = md_5.toString();
    print('digest password : $digestOfPassword');

    final keyToAscii = decryptedSecretKey.toAscii();
    final keyToEncryptText = generateKey(keyToAscii);

    final encrypter = Encrypter(
      AES(Key(keyToEncryptText), mode: AESMode.ecb, padding: 'PKCS7'),
    );

    final encryptedText = encrypter.encrypt(text, iv: IV(ivBytes));

    return encryptedText.base64;
  }

  String decryptText(String text, String key) {
    Uint8List secretKey = generateKey(key);
    Uint8List decodeCipherText = base64Decode(text);
    final encrypter =
        Encrypter(AES(Key(secretKey), mode: AESMode.cbc, padding: null));

    final decryptedText = encrypter.decrypt(Encrypted(decodeCipherText), iv: IV(ivBytes));
    return decryptedText;
  }
}

extension StringExtensions on String {
  String toAscii() {
    var s = '';
    for (var char in runes) {
      s = '$s${char.toInt()},';
    }
    return s.replaceAll(RegExp(','), '');
  }
}

class YXBpYW1pa29t {
  static String api_main =
      "ZGlsYXJhbmcgbWVuZ2d1bmFrYW4gYXBpIGFtaWtvbSB0YW5wYSBzZWl6aW4gcGloYWsgaW5ub3ZhdGlvbiBjZW50ZXI="; // Your API Main
  static String secret_key =
      "Dr3KZiF95eOzZ83+3SLNfdFFmv3Dzh2zihvXIobs1gUtSLMzIdSSafMmFDyjdnge"; // Your Secret Key
}
