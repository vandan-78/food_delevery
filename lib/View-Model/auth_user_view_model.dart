import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Core/Constants/keys.dart';

class AuthUserNotifier extends StateNotifier<String?> {
  AuthUserNotifier() : super(null) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString(kAuthTokenKey);
    debugPrint("token loaded: $token");
    state = token;
  }

  Future<String?> loadTokenNow() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(kAuthTokenKey);
  }

  Future<void> saveToken(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(kAuthTokenKey, token);
    state = token;
  }

  Future<void> clearToken() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(kAuthTokenKey);
    state = null;
  }
}

final authUserProvider = StateNotifierProvider<AuthUserNotifier, String?>((ref) {
  return AuthUserNotifier();
});
