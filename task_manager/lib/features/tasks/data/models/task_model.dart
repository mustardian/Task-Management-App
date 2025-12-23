import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/task.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  const TaskModel._();

  const factory TaskModel({
    required String id,
    required String title,
    required String description,
    required DateTime dueDate,
    required String priority, // Store as String in DB
    required bool isCompleted,
    required String userId,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  factory TaskModel.fromEntity(TaskEntity task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      priority: task.priority.name,
      isCompleted: task.isCompleted,
      userId: task.userId,
    );
  }

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel.fromJson(data).copyWith(id: doc.id);
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == priority,
        orElse: () => TaskPriority.medium,
      ),
      isCompleted: isCompleted,
      userId: userId,
    );
  }
}
