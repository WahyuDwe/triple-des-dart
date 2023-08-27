import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_des/dart_des.dart';
import 'package:encrypt/encrypt.dart';
import 'package:test_encrypt/encrypt_helper.dart';

final expectResult = 'h2Tcu/sryFlOH+WfHBuidUxamcexjEnFbYEgWU+aL1o=';

final secretKey = 'EBljyrGbREcZOIpNNahDELPLEJHfaraWnsLr';

void main(List<String> arguments) {

  final encryptHelper = EncryptHelper();
  String userId = '20.11.3356';
  String presenceCode = 'zpLUQ';
  String formatData = '$presenceCode;$userId;53375-34';
  // final data = encryptHelper.encryptText(formatData);
  print('format data: $formatData');
  // print('expect result : $expectResult');
  // print('result data : $data');




}

/// using dart_des packages
void usingDartDes() {

  final encryptHelper = EncryptHelper();
  String userId = '20.11.3356';
  String presenceCode = 'zpLUQ';
  String formatData = '$presenceCode;$userId;53375-34';
  // final data = encryptHelper.encryptText(formatData);
  //
  print('format data: $formatData');
  Uint8List data = encryptHelper.generateKey(secretKey.toAscii());
  final keyBytes = List<int>.from(data).sublist(0, 24);
  var j = 0;
  var k = 16;
  while (j < 8) {
    keyBytes[k++] = keyBytes[j++];
  }

  print('key length : ${data.lengthInBytes}');
  print('key bytes : $keyBytes');
  print('key bytes base 64 : ${base64.encode(keyBytes)}');
  print('new key length : ${keyBytes.length}');

  DES3 des3ecb = DES3(key: keyBytes, mode: DESMode.ECB, iv: DES.IV_ZEROS, paddingType: DESPaddingType.PKCS7);

  List<int> encrypted = des3ecb.encrypt(formatData.codeUnits);
  print('format data code units : ${formatData.codeUnits}');

  List<int> decrypted = des3ecb.decrypt(base64Decode(expectResult));


  print('DES mode: ECB');
  print('encrypted: $encrypted');
  print('encrypted (base64): ${base64.encode(encrypted)}');
  print('decrypted: $decrypted');
  print('decrypted (utf8): ${utf8.decode(decrypted)}');
}




