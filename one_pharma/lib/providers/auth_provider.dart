import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_model.dart';
import '../data/mock/mock_data.dart';

class AuthState {
  final UserModel? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isAuthenticated = true,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState(user: MockData.currentUser));

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 600));
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      user: MockData.currentUser.copyWith(email: email),
    );
  }

  Future<void> signUp(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 600));
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      user: UserModel(
        id: 'user_new',
        name: name,
        email: email,
        phone: '0569 - 8963 - 5632',
        address: 'House # 60 , Sector #12, Road# 20\nDhaka-1230',
      ),
    );
  }

  void updateProfile({
    String? name,
    String? phone,
    String? email,
    String? address,
  }) {
    if (state.user != null) {
      state = state.copyWith(
        user: state.user!.copyWith(
          name: name,
          phone: phone,
          email: email,
          address: address,
        ),
      );
    }
  }

  void signOut() {
    state = const AuthState(isAuthenticated: false, user: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
