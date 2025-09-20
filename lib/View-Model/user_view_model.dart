import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Model/State Model/user_state.dart';
import '../Repository/user_repository.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(UserRepository());
});

class UserNotifier extends StateNotifier<UserState> {
  final UserRepository _repo;

  UserNotifier(this._repo) : super(UserState());

  Future<void> fetchUsers() async {
    try {
      state = state.copyWith(isLoading: true,error: null);
      final result = await _repo.fetchUserData();
      state = state.copyWith(users: result.users, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
