import 'package:shared_preferences/shared_preferences.dart';
import '../domain/user.dart';
import 'dart:convert';

class AuthRepository {
  static const _userKey = 'currentUser';

  Future<User?> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);
    if (jsonString == null) return null;
    return User.fromJson(json.decode(jsonString));
  }

  Future<User> login(String email, String password) async {
    // Simulate backend delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app you'd call your .NET API here
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: email.split('@').first,
      email: email,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));

    return user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
