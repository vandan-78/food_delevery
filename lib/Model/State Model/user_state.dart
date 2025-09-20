import 'package:mvvm_folder_strucutre/Model/user_response_model.dart';

class UserState {
  final List<User> users;
  final String? error;
  final bool isLoading;

  UserState({this.users = const [], this.error, this.isLoading = false});

  UserState copyWith({List<User>? users, String? error, bool? isLoading}) {
    return UserState(
      users: users ?? this.users,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
