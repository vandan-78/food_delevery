import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/State Model/auth_state.dart';
import '../Repository/auth_respository.dart';
import '../Repository/auth_user_repository.dart';

class AuthNotifier extends StateNotifier<AuthResponseStateModel> {
  final AuthRepository _repo;
  final Ref _ref;

  AuthNotifier(this._repo,this._ref) : super(AuthResponseStateModel.initial());

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repo.signIn(email, password);
      final e_mail = user?.email;

      if (user != null) {
        final token = await user.getIdToken();

        // 1️⃣ get Firestore user profile by uid
        final profile = await _repo.fetchUserProfile(user.uid);

        if (profile != null) {
          final username = profile["username"] ?? "";

          // 2️⃣ Save into SharedPreferences
          final prefs = await AuthUserRepository.create();
          await prefs.saveToken(token!);
          await prefs.saveUserName(username);
          await prefs.saveUserEmail(e_mail!);

          debugPrint("Login Success -> email: ${user.email}");
          debugPrint("Stored username: $username");
          debugPrint("Stored token: $token");
        }
      }

      state = state.copyWith(isLoading: false, userLogin: user);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    }
  }

  Future<void> signUp(
      String email,
      String password,
      String userName,
      ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = await _repo.signUp(email, password, userName);

      if (user != null) {
        debugPrint("✅ User Registered: ${user.email}");

        state = state.copyWith(isLoading: false, userSignUp: user);


      } else {
        state = state.copyWith(isLoading: false, errorMessage: "User creation failed");
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    }
  }


  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repo.signOut();
      state = AuthResponseStateModel.initial();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthResponseStateModel>((ref) {
  return AuthNotifier(AuthRepository(),ref);
});