import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/task.dart';
import '../controllers/task_controller.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';

class AddEditTaskScreen extends ConsumerStatefulWidget {
  final TaskEntity? task;
  const AddEditTaskScreen({super.key, this.task});

  @override
  ConsumerState<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends ConsumerState<AddEditTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TaskPriority _priority = TaskPriority.medium;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDate = widget.task!.dueDate;
      _priority = widget.task!.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final user = ref.read(authControllerProvider).value;
      if (user == null) {
        // User is null, cannot save task
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not logged in')));
        return;
      }

      final isEditing = widget.task != null;
      final task = TaskEntity(
        id: isEditing ? widget.task!.id : const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _selectedDate,
        priority: _priority,
        isCompleted: isEditing ? widget.task!.isCompleted : false,
        userId: user.id,
      );

      if (isEditing) {
        await ref.read(taskControllerProvider.notifier).updateTask(task);
      } else {
        await ref.read(taskControllerProvider.notifier).createTask(task);
      }

      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : 'Required',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Priority'),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<TaskPriority>(
                          value: _priority,
                          isDense: true,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _priority = value);
                            }
                          },
                          items: TaskPriority.values.map((p) {
                            return DropdownMenuItem(
                              value: p,
                              child: Text(p.name.toUpperCase()),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Due Date'),
                subtitle: Text(DateFormat.yMMMd().format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
