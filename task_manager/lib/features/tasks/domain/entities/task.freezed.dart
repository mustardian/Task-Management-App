// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TaskEntity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  TaskPriority get priority => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskEntityCopyWith<TaskEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskEntityCopyWith<$Res> {
  factory $TaskEntityCopyWith(
    TaskEntity value,
    $Res Function(TaskEntity) then,
  ) = _$TaskEntityCopyWithImpl<$Res, TaskEntity>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    DateTime dueDate,
    TaskPriority priority,
    bool isCompleted,
    String userId,
  });
}

/// @nodoc
class _$TaskEntityCopyWithImpl<$Res, $Val extends TaskEntity>
    implements $TaskEntityCopyWith<$Res> {
  _$TaskEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? dueDate = null,
    Object? priority = null,
    Object? isCompleted = null,
    Object? userId = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            dueDate: null == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as TaskPriority,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskEntityImplCopyWith<$Res>
    implements $TaskEntityCopyWith<$Res> {
  factory _$$TaskEntityImplCopyWith(
    _$TaskEntityImpl value,
    $Res Function(_$TaskEntityImpl) then,
  ) = __$$TaskEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    DateTime dueDate,
    TaskPriority priority,
    bool isCompleted,
    String userId,
  });
}

/// @nodoc
class __$$TaskEntityImplCopyWithImpl<$Res>
    extends _$TaskEntityCopyWithImpl<$Res, _$TaskEntityImpl>
    implements _$$TaskEntityImplCopyWith<$Res> {
  __$$TaskEntityImplCopyWithImpl(
    _$TaskEntityImpl _value,
    $Res Function(_$TaskEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? dueDate = null,
    Object? priority = null,
    Object? isCompleted = null,
    Object? userId = null,
  }) {
    return _then(
      _$TaskEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        dueDate: null == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as TaskPriority,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$TaskEntityImpl implements _TaskEntity {
  const _$TaskEntityImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.userId,
  });

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final DateTime dueDate;
  @override
  final TaskPriority priority;
  @override
  final bool isCompleted;
  @override
  final String userId;

  @override
  String toString() {
    return 'TaskEntity(id: $id, title: $title, description: $description, dueDate: $dueDate, priority: $priority, isCompleted: $isCompleted, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    dueDate,
    priority,
    isCompleted,
    userId,
  );

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskEntityImplCopyWith<_$TaskEntityImpl> get copyWith =>
      __$$TaskEntityImplCopyWithImpl<_$TaskEntityImpl>(this, _$identity);
}

abstract class _TaskEntity implements TaskEntity {
  const factory _TaskEntity({
    required final String id,
    required final String title,
    required final String description,
    required final DateTime dueDate,
    required final TaskPriority priority,
    required final bool isCompleted,
    required final String userId,
  }) = _$TaskEntityImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  DateTime get dueDate;
  @override
  TaskPriority get priority;
  @override
  bool get isCompleted;
  @override
  String get userId;

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskEntityImplCopyWith<_$TaskEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
