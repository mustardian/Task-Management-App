import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> signIn(String email, String password);
  Future<Either<Failure, AppUser>> signUp(String email, String password);
  Future<Either<Failure, void>> signOut();
  Stream<AppUser?> get currentUser;
}
