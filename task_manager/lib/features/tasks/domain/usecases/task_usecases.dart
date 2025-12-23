import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class TaskUseCases {
  final TaskRepository _repository;

  TaskUseCases(this._repository);

  Future<Either<Failure, List<TaskEntity>>> getTasks(String userId) {
    return _repository.getTasks(userId);
  }

  Future<Either<Failure, void>> createTask(TaskEntity task) {
    return _repository.createTask(task);
  }

  Future<Either<Failure, void>> updateTask(TaskEntity task) {
    return _repository.updateTask(task);
  }

  Future<Either<Failure, void>> deleteTask(String taskId) {
    return _repository.deleteTask(taskId);
  }
  
  Stream<List<TaskEntity>> watchTasks(String userId) {
    return _repository.watchTasks(userId);
  }
}
