import 'package:flutter/material.dart';

import '../../../domain/models/course.dart';

/// Kartu satu mata kuliah. Dipakai di Beranda dan Jadwal,
/// jadi letaknya di ui/core, bukan di salah satu fitur.
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              child: Column(
                children: [
                  Text(course.start, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(course.end, style: TextStyle(color: colors.outline)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.place_outlined, size: 16, color: colors.outline),
                      const SizedBox(width: 4),
                      Text(course.room, style: TextStyle(color: colors.outline)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
