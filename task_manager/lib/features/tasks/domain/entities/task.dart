import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';

enum TaskPriority { high, medium, low }

@freezed
class TaskEntity with _$TaskEntity {
  const factory TaskEntity({
    required String id,
    required String title,
    required String description,
    required DateTime dueDate,
    required TaskPriority priority,
    required bool isCompleted,
    required String userId,
  }) = _TaskEntity;
}
