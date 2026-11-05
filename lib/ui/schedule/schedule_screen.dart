import 'package:flutter/material.dart';

import '../../utils/date_format.dart';
import '../core/widgets/course_card.dart';
import '../core/widgets/error_view.dart';
import 'schedule_view_model.dart';

/// View Jadwal: pilihan hari di atas, daftar kuliah di bawah.
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key, required this.viewModel});

  final ScheduleViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Kuliah')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.error != null) {
            return ErrorView(onRetry: viewModel.load);
          }

          final courses = viewModel.coursesOfDay;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SegmentedButton<int>(
                showSelectedIcon: false,
                segments: [
                  for (var day = 1; day <= 5; day++)
                    ButtonSegment(value: day, label: Text(hari[day - 1].substring(0, 3))),
                ],
                selected: {viewModel.selectedDay},
                onSelectionChanged: (days) => viewModel.selectDay(days.first),
              ),
              const SizedBox(height: 16),
              if (courses.isEmpty) const Text('Tidak ada kuliah.'),
              for (final course in courses)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CourseCard(course: course),
                ),
            ],
          );
        },
      ),
    );
  }
}
