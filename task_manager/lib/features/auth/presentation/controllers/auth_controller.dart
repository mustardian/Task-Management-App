import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(firebaseAuthProvider));
});

final authUseCasesProvider = Provider<AuthUseCases>((ref) {
  return AuthUseCases(ref.watch(authRepositoryProvider));
});

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<AppUser?>>((ref) {
  return AuthController(ref.watch(authUseCasesProvider));
});

class AuthController extends StateNotifier<AsyncValue<AppUser?>> {
  final AuthUseCases _useCases;

  AuthController(this._useCases) : super(const AsyncValue.loading()) {
    _checkInitialStatus();
    _listenToAuthChanges();
  }

  void _checkInitialStatus() async {
    // Initial check is handled by stream, but we set loading first.
  }

  void _listenToAuthChanges() {
    _useCases.currentUser.listen((user) {
      state = AsyncValue.data(user);
    });
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await _useCases.signIn(email, password);
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (user) => state = AsyncValue.data(user),
    );
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await _useCases.signUp(email, password);
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (user) => state = AsyncValue.data(user),
    );
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    await _useCases.signOut();
    // Stream will update the state to null
  }
}
