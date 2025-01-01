import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserTokenSaver{
  final FlutterSecureStorage secureStorage =const FlutterSecureStorage();
  static const  USER_TOKEN_KEY='user_key';
  String token='null';
// Save token securely
  Future<void> saveToken(String key) async {
    DateTime currentTimeDate=DateTime.now();
    String token=key+currentTimeDate.toString();
    await secureStorage.write(key: USER_TOKEN_KEY, value:token);
  }
// Retrieve token securely
  Future<String> getToken() async {
    token=(await secureStorage.read(key: USER_TOKEN_KEY))!;
    return token;
  }


}