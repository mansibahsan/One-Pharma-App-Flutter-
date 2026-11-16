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

  UserRole get activeRole => user?.userRole ?? UserRole.patient;
  bool get isDoctor => activeRole == UserRole.doctor;

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

  Future<void> signIn(
    String email,
    String password, {
    UserRole role = UserRole.patient,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 500));
    final baseUser =
        role == UserRole.doctor ? MockData.currentDoctor : MockData.currentUser;
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      user: baseUser.copyWith(email: email.isNotEmpty ? email : baseUser.email),
    );
  }

  void signInAsPatient() {
    state = const AuthState(
      isAuthenticated: true,
      isLoading: false,
      user: MockData.currentUser,
    );
  }

  void signInAsDoctor() {
    state = const AuthState(
      isAuthenticated: true,
      isLoading: false,
      user: MockData.currentDoctor,
    );
  }

  void switchRole(UserRole role) {
    if (role == UserRole.doctor) {
      signInAsDoctor();
    } else {
      signInAsPatient();
    }
  }

  Future<void> signUp(
    String name,
    String email,
    String password, {
    UserRole role = UserRole.patient,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 500));
    final baseUser =
        role == UserRole.doctor ? MockData.currentDoctor : MockData.currentUser;
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      user: baseUser.copyWith(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        userRole: role,
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
