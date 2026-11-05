import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home_screen.dart';
import '../home/home_view_model.dart';
import '../schedule/schedule_screen.dart';
import '../schedule/schedule_view_model.dart';
import '../tasks/tasks_screen.dart';
import '../tasks/tasks_view_model.dart';

/// Kerangka aplikasi: tiga tab di bawah layar.
///
/// Di sini setiap view model dibuat dan diberi repository yang dibutuhkan.
/// Layar tidak membuat repository sendiri; ia hanya menerima view model.
class AppShell extends StatefulWidget {
  const AppShell({super.key, this.clock});

  /// Jam aplikasi. Diisi tanggal tetap saat membuat screenshot/test.
  final DateTime Function()? clock;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  late final HomeViewModel _home = HomeViewModel(
    scheduleRepository: context.read(),
    taskRepository: context.read(),
    clock: widget.clock,
  );
  late final ScheduleViewModel _schedule = ScheduleViewModel(
    repository: context.read(),
    clock: widget.clock,
  );
  late final TasksViewModel _tasks = TasksViewModel(repository: context.read());

  @override
  void dispose() {
    _home.dispose();
    _schedule.dispose();
    _tasks.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack menjaga isi tab tetap hidup saat berpindah tab.
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(viewModel: _home),
          ScheduleScreen(viewModel: _schedule),
          TasksScreen(viewModel: _tasks),
        ],
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: _home,
        builder: (context, _) {
          final pending = _home.pendingTasks.length;
          return NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (index) => setState(() => _index = index),
            destinations: [
              const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Beranda'),
              const NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Jadwal'),
              NavigationDestination(
                icon: Badge(isLabelVisible: pending > 0, label: Text('$pending'), child: const Icon(Icons.task_alt_outlined)),
                selectedIcon: Badge(isLabelVisible: pending > 0, label: Text('$pending'), child: const Icon(Icons.task_alt)),
                label: 'Tugas',
              ),
            ],
          );
        },
      ),
    );
  }
}
