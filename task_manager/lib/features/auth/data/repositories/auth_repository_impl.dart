import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Stream<AppUser?> get currentUser {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return AppUser(id: user.uid, email: user.email ?? '');
    });
  }

  @override
  Future<Either<Failure, AppUser>> signIn(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      return Right(AppUser(id: user.uid, email: user.email ?? ''));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Authentication failed'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signUp(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      return Right(AppUser(id: user.uid, email: user.email ?? ''));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Registration failed'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
