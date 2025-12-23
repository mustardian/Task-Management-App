// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      priority: json['priority'] as String,
      isCompleted: json['isCompleted'] as bool,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'dueDate': instance.dueDate.toIso8601String(),
      'priority': instance.priority,
      'isCompleted': instance.isCompleted,
      'userId': instance.userId,
    };
