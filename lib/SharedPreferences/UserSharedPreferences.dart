import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static const _nameKey = 'name';
  static const _userIdKey = 'userId';
  static const _typeOfUserKey = 'typeOfUser';

  // Method to load all user data (name, userId, typeOfUser)
  Future<Map<String, String?>> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the stored values or return null if not found
    String? name = prefs.getString(_nameKey);
    String? userId = prefs.getString(_userIdKey);
    String? typeOfUser = prefs.getString(_typeOfUserKey);

    return {
      'name': name,
      'userId': userId,
      'typeOfUser': typeOfUser,
    };
  }

  // Method to save all user data (name, userId, typeOfUser)
  Future<void> saveUserData(String name, String userId, String typeOfUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the data to SharedPreferences
    await prefs.setString(_nameKey, name);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_typeOfUserKey, typeOfUser);
  }
}
