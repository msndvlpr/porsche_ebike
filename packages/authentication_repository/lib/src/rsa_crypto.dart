import 'dart:convert';

import 'package:encrypt/encrypt.dart';

String encryptData(String text) {

  // A sample key for encryption
  final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');

  final b64key = Key.fromUtf8(base64Url.encode(key.bytes).substring(0, 32));

  final fernet = Fernet(b64key);
  final encrypter = Encrypter(fernet);

  final encrypted = encrypter.encrypt(text);

  return encrypted.base64;
}
