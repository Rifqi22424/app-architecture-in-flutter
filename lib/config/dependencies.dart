import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/schedule_repository.dart';
import '../data/repositories/task_repository.dart';
import '../data/services/campus_service.dart';

/// Daftar semua "bahan" lapisan data, dibuat SATU KALI untuk seluruh aplikasi.
///
/// Urutannya penting: service dulu, lalu repository yang memakainya.
/// `context.read()` mengambil objek yang sudah didaftarkan di atasnya.
List<SingleChildWidget> get providers => [
      Provider(create: (context) => CampusService()),
      Provider(create: (context) => ScheduleRepository(service: context.read())),
      ChangeNotifierProvider(create: (context) => TaskRepository(service: context.read())),
    ];
