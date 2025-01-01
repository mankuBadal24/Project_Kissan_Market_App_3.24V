import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
const  USER_TOKEN_KEY='user_token';
class SessionMangement {
  String? _userToken;
  String? get userToken=>_userToken;

  Future<void>loadSession() async{
    final prefs=await SharedPreferences.getInstance();
    _userToken=prefs.getString(USER_TOKEN_KEY);
  }

  Future<void> saveSession(String token)async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.setString(USER_TOKEN_KEY, token);
    _userToken=token;
    print("saving session----${_userToken}");
  }
  Future<void>clearSession()async{
    final  pref=await SharedPreferences.getInstance();
    await pref.remove(USER_TOKEN_KEY);
    _userToken=null;
    // notifyListeners();
  }
}