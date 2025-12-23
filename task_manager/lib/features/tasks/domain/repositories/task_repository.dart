import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks(String userId);
  Future<Either<Failure, void>> createTask(TaskEntity task);
  Future<Either<Failure, void>> updateTask(TaskEntity task);
  Future<Either<Failure, void>> deleteTask(String taskId);
  Stream<List<TaskEntity>> watchTasks(String userId);
}
