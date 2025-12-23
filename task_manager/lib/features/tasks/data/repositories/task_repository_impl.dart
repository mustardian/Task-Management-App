import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepositoryImpl(this._firestore);

  @override
  Future<Either<Failure, void>> createTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await _firestore.collection('tasks').doc(task.id).set(taskModel.toJson());

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    // Note: Deleting requires userId to find the path, but the interface only has taskId.
    // In a real app, we should probably pass the TaskEntity or userId.
    // For this assignment, let's assume we can get userId from valid context or we change the interface.
    // However, to stick to the defined interface, I might need to query simple collection group or pass user ID.
    // Wait, the interface `deleteTask(String taskId)` is problematic for subcollections if I don't know the user.
    // I will modify the requirement slightly to assume we have the current user ID available in the repository via a provider or similar,
    // OR I will fix the interface to include userId, OR I will store tasks in a top-level collection with userId field.
    // Top-level collection is easier for querying by assignment requirements (though subcollections are better for security rules usually).
    // Let's use top-level 'tasks' collection for simplicity and querying.
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .get();

      final tasks = snapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc).toEntity())
          .toList();

      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await _firestore
          .collection('tasks')
          .doc(taskModel.id)
          .update(taskModel.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  @override
  Stream<List<TaskEntity>> watchTasks(String userId) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskModel.fromFirestore(doc).toEntity())
              .toList(),
        );
  }
}
