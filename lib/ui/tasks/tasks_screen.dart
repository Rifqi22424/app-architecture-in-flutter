import 'package:flutter/material.dart';

import '../../domain/models/task.dart';
import '../../utils/date_format.dart';
import '../core/widgets/error_view.dart';
import 'tasks_view_model.dart';

/// View Tugas: centang tugas yang sudah selesai.
class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key, required this.viewModel});

  final TasksViewModel viewModel;

  Future<void> _toggle(BuildContext context, Task task) async {
    final ok = await viewModel.toggle(task);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan. Coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tugas')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.error != null) {
            return ErrorView(onRetry: viewModel.load);
          }

          final text = Theme.of(context).textTheme;
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _Header('Belum selesai (${viewModel.pending.length})', style: text.titleSmall),
              for (final task in viewModel.pending) _taskTile(context, task),
              _Header('Selesai (${viewModel.done.length})', style: text.titleSmall),
              for (final task in viewModel.done) _taskTile(context, task),
            ],
          );
        },
      ),
    );
  }

  Widget _taskTile(BuildContext context, Task task) {
    return CheckboxListTile(
      value: task.done,
      onChanged: (_) => _toggle(context, task),
      title: Text(
        task.title,
        style: task.done ? const TextStyle(decoration: TextDecoration.lineThrough) : null,
      ),
      subtitle: Text('${task.courseName}\nTenggat ${formatTanggal(task.due)}'),
      isThreeLine: true,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.label, {this.style});

  final String label;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(label, style: style),
    );
  }
}
