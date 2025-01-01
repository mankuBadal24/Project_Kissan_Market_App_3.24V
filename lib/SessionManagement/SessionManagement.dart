import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class SessionManagement {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  static const  USER_TOKEN_KEY='login_token';
  static const TYPE_OF_USER_KEY='type_of_user';
  String token='null';

  Future<String>loadSession() async{
    try {
      token=(await secureStorage.read(key: USER_TOKEN_KEY))!;
      return token;
    }
    catch(e){
        print("failed to load session $e");
    }

    return token;
  }
  Future<String?>getTypeOfUser()async{
   String? type;
    type=await secureStorage.read(key: TYPE_OF_USER_KEY,);
    return type;
  }

  Future<void> saveSession(String key,String type)async{
    try{
      DateTime currentTimeDate=DateTime.now();
      String token=key+currentTimeDate.toString();
      await secureStorage.write(key: USER_TOKEN_KEY, value:token);
      await secureStorage.write(key: TYPE_OF_USER_KEY, value: type);
    }
    catch(e){
      if (kDebugMode) {
        print("Failed to save session");
      }
    }

  }
  Future<void>clearSession()async{
    try{
      await secureStorage.write(key: USER_TOKEN_KEY,value: 'null');
      await secureStorage.delete(key: TYPE_OF_USER_KEY);
    }
    catch(e){
      if (kDebugMode) {
        print('failed to clear the session');
      }
    }


  }
}