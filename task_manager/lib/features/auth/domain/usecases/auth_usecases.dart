import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class AuthUseCases {
  final AuthRepository _repository;

  AuthUseCases(this._repository);

  Future<Either<Failure, AppUser>> signIn(String email, String password) {
    return _repository.signIn(email, password);
  }

  Future<Either<Failure, AppUser>> signUp(String email, String password) {
    return _repository.signUp(email, password);
  }

  Future<Either<Failure, void>> signOut() {
    return _repository.signOut();
  }

  Stream<AppUser?> get currentUser => _repository.currentUser;
}
