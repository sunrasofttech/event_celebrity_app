// import 'package:encrypt/encrypt.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
//
// class EncryptionService {
//   late final Key _encryptKey;
//   late final Key _decryptKey;
//   final IV _iv = IV.fromLength(16); // Initialization Vector
//
//   EncryptionService() {
//     _encryptKey = Key.fromUtf8(dotenv.env['ENCRYPTION_KEY_REQUEST'] ?? '');
//     _decryptKey = Key.fromUtf8(dotenv.env['ENCRYPTION_KEY_RESPONSE'] ?? '');
//   }
//
//   /// Encrypt request body
//   String encrypt(String plainText) {
//     final encrypter = Encrypter(AES(_encryptKey));
//     return encrypter.encrypt(plainText, iv: _iv).base64;
//   }
//
//   /// Decrypt response body
//   String decrypt(String encryptedText) {
//     final encrypter = Encrypter(AES(_decryptKey));
//     return encrypter.decrypt64(encryptedText, iv: _iv);
//   }
// }

import 'dart:convert';
import 'dart:developer';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  Key? _key; // Single key for both encryption and decryption

  /// Initialize encryption key from secure storage
  Future<bool> init({bool initAgain = false, String? keyy}) async {
    // If force initAgain is requested, always reset
    if (initAgain && keyy != null) {
      _key = Key.fromBase64(keyy);
      log("🔄 Key reinitialized with provided key: $keyy");
      return true;
    }

    // If already initialized, no need to re-read unless explicitly asked
    // if (_key != null && !initAgain) {
    //   return true;
    // }

    // Read from secure storage
    final keyFromStorage = await _secureStorage.read(
      key: dotenv.env['ENCRYPTION_KEY_REQUEST'] ?? 'ENCRYPTION_KEY_REQUEST',
    );

    if (keyFromStorage == null || keyFromStorage.isEmpty) {
      log('❌ Encryption key not found in secure storage');
      return false;
    }

    _key = Key.fromBase64(keyFromStorage);
    log("✅ Key initialized from secure storage: $keyFromStorage");
    return true;
  }

  Future<void> resetKey() async {
    _key = null;
    log("🔑 Encryption key reset (logout)");
  }

  /// Encrypt text and return map with base64 data and IV
  Map<String, String> encryptWithIV(String plainText) {
    //LBa2MSB1+qIpk0OcVJ4nU/SZSGEJhbq370pI6q2RKt8=
    log("EXCRPTION WITH KEY:- ${_key!.base64}");
    final iv = IV.fromSecureRandom(16); // Generate random IV
    final encrypter = Encrypter(AES(_key!, mode: AESMode.cbc, padding: 'PKCS7'));
    log("iv-----> ${base64Encode(iv.bytes)}");
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    log("EXCRPTION:- $encrypted");
    return {
      "data": encrypted.base64, // Encrypted string
      "iv": base64Encode(iv.bytes), // IV in base64
    };
  }

  /// Decrypt text using base64 IV
  String decryptWithIV(String encryptedText, String ivBase64) {
    final iv = IV.fromBase64(ivBase64);
    log("[decryptWithIV] encryptedText:---- $encryptedText, iv8:----- $ivBase64, iv---------->>> $iv");
    final encrypter = Encrypter(AES(_key!, mode: AESMode.cbc, padding: 'PKCS7'));

    return encrypter.decrypt64(encryptedText, iv: iv);
  }
}
