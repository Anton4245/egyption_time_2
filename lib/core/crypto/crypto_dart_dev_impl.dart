import 'package:ejyption_time_2/core/crypto/cripto_interface.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class CryptoDartDevImpl with CryptoInterface {
  @override
  String convertStringWithPassword(intString, intPassword) {
    var key = utf8.encode(intPassword);
    var bytes = utf8.encode(intString);

    var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
    Digest digest = hmacSha256.convert(bytes);

    return digest.toString(); //thus obtaining hex code
  }
}
