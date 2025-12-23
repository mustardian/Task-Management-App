import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/features/tasks/presentation/screens/add_edit_task_screen.dart';
import '../../domain/entities/task.dart';
import '../controllers/task_controller.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(filteredTaskListProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-task'),
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, ref),
          SliverToBoxAdapter(child: _buildFilters(context, ref)),
          tasksAsync.when(
            data: (tasks) {
              if (tasks.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No tasks found')),
                );
              }

              final groupedTasks = _groupTasks(tasks);
              var groups = groupedTasks.entries
                  .where((entry) => entry.value.isNotEmpty)
                  .toList();

              final sort = ref.watch(taskSortProvider);
              if (sort == TaskSort.dueDateDesc) {
                groups = groups.reversed.toList();
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return _buildGroup(context, ref, groups[index]);
                }, childCount: groups.length),
              );
            },
            error: (err, stack) =>
                SliverFillRemaining(child: Center(child: Text('Error: $err'))),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<TaskEntity>> _groupTasks(List<TaskEntity> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));

    final Map<String, List<TaskEntity>> groups = {
      'Overdue': [],
      'Today': [],
      'Tomorrow': [],
      'This Week': [],
      'Later': [],
    };

    for (var task in tasks) {
      // Assuming tasks have a valid non-null dueDate
      final d = task.dueDate;
      final taskDate = DateTime(d.year, d.month, d.day);

      if (taskDate.isBefore(today)) {
        if (!task.isCompleted) {
          groups['Overdue']!.add(task);
        } else {
          groups['Overdue']!.add(task);
        }
      } else if (taskDate.isAtSameMomentAs(today)) {
        groups['Today']!.add(task);
      } else if (taskDate.isAtSameMomentAs(tomorrow)) {
        groups['Tomorrow']!.add(task);
      } else if (taskDate.isBefore(nextWeek)) {
        groups['This Week']!.add(task);
      } else {
        groups['Later']!.add(task);
      }
    }
    return groups;
  }

  Widget _buildGroup(
    BuildContext context,
    WidgetRef ref,
    MapEntry<String, List<TaskEntity>> entry,
  ) {
    if (entry.value.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            entry.key,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: entry.key == 'Overdue'
                  ? Colors.red
                  : Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[700],
            ),
          ),
        ),
        ...entry.value.map(
          (task) => Dismissible(
            key: Key(task.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) {
              ref.read(taskControllerProvider.notifier).deleteTask(task.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Task deleted'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      ref
                          .read(taskControllerProvider.notifier)
                          .createTask(task);
                    },
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: _TaskCard(task: task),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).asData?.value;
    final userLetter = user?.email.isNotEmpty == true
        ? user!.email[0].toUpperCase()
        : 'U';

    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: true,
      centerTitle: true,
      toolbarHeight: 80, // Taller toolbar for the search bar
      title: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors
                    .grey
                    .shade200 // Light grey for light mode
              : Colors.grey.shade800, // Dark grey for dark mode
          borderRadius: BorderRadius.circular(25), // Pill shape
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  onChanged: (val) {
                    ref.read(searchQueryProvider.notifier).state = val;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search your notes',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    filled: false,
                    fillColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton(
                offset: const Offset(0, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    enabled: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Signed in as',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          user?.email ?? '',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Logout', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'logout') {
                    ref.read(authControllerProvider.notifier).signOut();
                  }
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    userLetter,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(taskFilterProvider);
    final currentSort = ref.watch(taskSortProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          DropdownButton<TaskSort>(
            value: currentSort,
            underline: Container(),
            isDense: true,
            items: const [
              DropdownMenuItem(
                value: TaskSort.dueDateAsc,
                child: Text('Earliest'),
              ),
              DropdownMenuItem(
                value: TaskSort.dueDateDesc,
                child: Text('Latest'),
              ),
            ],
            onChanged: (val) {
              if (val != null) ref.read(taskSortProvider.notifier).state = val;
            },
          ),
          const SizedBox(width: 12),
          Wrap(
            spacing: 8,
            children: TaskFilter.values.map((filter) {
              final isSelected = currentFilter == filter;
              return FilterChip(
                label: Text(filter.name.toUpperCase()),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    ref.read(taskFilterProvider.notifier).state = filter;
                  }
                },
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  final TaskEntity task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color cardColor;
    Color borderColor;

    // Priority-based card colors
    switch (task.priority) {
      case TaskPriority.high:
        cardColor = Colors.red.shade50;
        borderColor = Colors.red.shade200;
        break;
      case TaskPriority.medium:
        cardColor = Colors.orange.shade50;
        borderColor = Colors.orange.shade200;
        break;
      case TaskPriority.low:
        cardColor = Colors.green.shade50;
        borderColor = Colors.green.shade200;
        break;
    }

    // Dark mode adjustment
    if (Theme.of(context).brightness == Brightness.dark) {
      switch (task.priority) {
        case TaskPriority.high:
          cardColor = Colors.red.withOpacity(0.2);
          break;
        case TaskPriority.medium:
          cardColor = Colors.orange.withOpacity(0.2);
          break;
        case TaskPriority.low:
          cardColor = Colors.green.withOpacity(0.2);
          break;
      }
    }

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 1),
      ),
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.title.isNotEmpty)
                Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              if (task.title.isNotEmpty && task.description.isNotEmpty)
                const SizedBox(height: 8),
              if (task.description.isNotEmpty)
                Text(
                  task.description,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              const SizedBox(height: 12),
              // Checkbox and Date Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat.MMMd().format(task.dueDate),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (val) {
                      ref
                          .read(taskControllerProvider.notifier)
                          .updateTask(task.copyWith(isCompleted: val ?? false));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
