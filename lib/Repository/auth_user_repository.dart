import 'package:shared_preferences/shared_preferences.dart';
import '../Core/Constants/keys.dart';

class AuthUserRepository {
  final SharedPreferences _prefs;

  AuthUserRepository._(this._prefs);

  /// Factory constructor to initialize once
  static Future<AuthUserRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AuthUserRepository._(prefs);
  }

  // -------------------------------
  // 🔑 Token Methods
  // -------------------------------
  Future<void> saveToken(String token) async {
    await _prefs.setString(kAuthTokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(kAuthTokenKey);
  }

  Future<void> clearToken() async {
    await _prefs.remove(kAuthTokenKey);
  }

  // -------------------------------
  // 👤 Username Methods
  // -------------------------------
  Future<void> saveUserName(String userName) async {
    await _prefs.setString(kUserName, userName);
  }

  String? getUserName() {
    return _prefs.getString(kUserName);
  }

  Future<void> removeUserName() async {
    await _prefs.remove(kUserName);
  }

  // -------------------------------

  Future<void> saveUserEmail(String email) async {
    await _prefs.setString(kUserEmail, email);
  }

  String? getUserEmail() {
    return _prefs.getString(kUserEmail);
  }

  Future<void> removeUserEmail() async {
    await _prefs.remove(kUserEmail);
  }

// -------------------------------
// 👋 Onboarding Flag
// -------------------------------
  Future<void> setFirstTimeOpen(bool value) async {
    await _prefs.setBool(kFirstTimeOpen, value);
  }

  bool isFirstTimeOpen() {
    // default true (if null, consider it's first time)
    return _prefs.getBool(kFirstTimeOpen) ?? true;
  }

  // -------------------------------
  // 🚀 Clear All
  // -------------------------------
  Future<void> clearAll() async {
    await _prefs.remove(kAuthTokenKey);
    await _prefs.remove(kUserName);
  }
}
