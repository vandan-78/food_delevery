class LoginResponse {
  final String token;

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(token: json['token']);
  }

  @override
  String toString() => 'LoginResponse(token: $token)';
}


class SignupResponse {
  final int id;
  final String token;

  SignupResponse({required this.id, required this.token});

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      id: json['id'],
      token: json['token'],
    );
  }

  @override
  String toString() => 'SignupResponse(id: $id, token: $token)';
}
