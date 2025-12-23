import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/task_usecases.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(
    FirebaseFirestore.instance,
  ); // Direct instance for now, or use provider
});

final taskUseCasesProvider = Provider<TaskUseCases>((ref) {
  return TaskUseCases(ref.watch(taskRepositoryProvider));
});

// Stream provider to watch tasks from Firestore
final taskListStreamProvider = StreamProvider<List<TaskEntity>>((ref) {
  final user = ref.watch(authControllerProvider).asData?.value;
  if (user == null) return const Stream.empty();
  return ref.watch(taskUseCasesProvider).watchTasks(user.id);
});

// Filter state
final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);
final taskSortProvider = StateProvider<TaskSort>((ref) => TaskSort.dueDateAsc);
final searchQueryProvider = StateProvider<String>((ref) => '');

enum TaskFilter { all, completed, incomplete, high, medium, low }

enum TaskSort { dueDateAsc, dueDateDesc }

// Filtered and Sorted Tasks
final filteredTaskListProvider = Provider<AsyncValue<List<TaskEntity>>>((ref) {
  final tasksAsync = ref.watch(taskListStreamProvider);
  final filter = ref.watch(taskFilterProvider);
  final sort = ref.watch(taskSortProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  return tasksAsync.whenData((tasks) {
    var filtered = tasks.where((task) {
      // 1. Filter by Search Query
      if (query.isNotEmpty) {
        final matchesTitle = task.title.toLowerCase().contains(query);
        final matchesDesc = task.description.toLowerCase().contains(query);
        if (!matchesTitle && !matchesDesc) {
          return false;
        }
      }

      // 2. Filter by Category/Status
      switch (filter) {
        case TaskFilter.all:
          return true;
        case TaskFilter.completed:
          return task.isCompleted;
        case TaskFilter.incomplete:
          return !task.isCompleted;
        case TaskFilter.high:
          return task.priority == TaskPriority.high;
        case TaskFilter.medium:
          return task.priority == TaskPriority.medium;
        case TaskFilter.low:
          return task.priority == TaskPriority.low;
      }
    }).toList();

    filtered.sort((a, b) {
      if (sort == TaskSort.dueDateAsc) {
        return a.dueDate.compareTo(b.dueDate);
      } else {
        return b.dueDate.compareTo(a.dueDate);
      }
    });

    return filtered;
  });
});

final taskControllerProvider =
    StateNotifierProvider<TaskController, AsyncValue<void>>((ref) {
      return TaskController(ref.watch(taskUseCasesProvider));
    });

class TaskController extends StateNotifier<AsyncValue<void>> {
  final TaskUseCases _useCases;

  TaskController(this._useCases) : super(const AsyncValue.data(null));

  Future<void> createTask(TaskEntity task) async {
    state = const AsyncValue.loading();
    final result = await _useCases.createTask(task);
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
  }

  Future<void> updateTask(TaskEntity task) async {
    state = const AsyncValue.loading();
    final result = await _useCases.updateTask(task);
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
  }

  Future<void> deleteTask(String taskId) async {
    // Optimistic UI updates could be done here if using local state, but we rely on stream.
    // However, showing loading state is good.
    // state = const AsyncValue.loading(); // Optional: might flicker logic
    final result = await _useCases.deleteTask(taskId);
    if (result.isLeft()) {
      result.fold(
        (failure) =>
            state = AsyncValue.error(failure.message, StackTrace.current),
        (_) => null,
      );
    }
  }

  Future<void> toggleTaskCompletion(TaskEntity task) async {
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updated);
  }
}
