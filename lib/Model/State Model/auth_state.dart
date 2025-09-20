import 'package:firebase_auth/firebase_auth.dart';

class AuthResponseStateModel {
  final bool isLoading;
  final User? userLogin;
  final User? userSignUp;
  final String? errorMessage;

  const AuthResponseStateModel({
    this.isLoading = false,
    this.userLogin,
    this.userSignUp,
    this.errorMessage,
  });

  AuthResponseStateModel copyWith({
    bool? isLoading,
    User? userLogin,
    User? userSignUp,
    String? errorMessage,
  }) {
    return AuthResponseStateModel(
      isLoading: isLoading ?? this.isLoading,
      userLogin: userLogin ?? this.userLogin,
      userSignUp: userSignUp ?? this.userSignUp,
      errorMessage: errorMessage,
    );
  }

  factory AuthResponseStateModel.initial() {
    return const AuthResponseStateModel(isLoading: false, userLogin: null,userSignUp: null, errorMessage: null);
  }
}
