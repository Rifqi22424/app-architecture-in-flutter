import '../../domain/models/course.dart';
import '../services/campus_service.dart';

/// Repository: sumber kebenaran (source of truth) untuk data jadwal.
///
/// Tugasnya: mengambil data dari service, mengubahnya menjadi model,
/// dan menyimpan salinannya (cache) supaya tidak meminta ulang ke server.
class ScheduleRepository {
  ScheduleRepository({required CampusService service}) : _service = service;

  final CampusService _service;
  List<Course>? _cache;

  Future<List<Course>> getSchedule() async {
    if (_cache != null) return _cache!;

    final data = await _service.getSchedule();
    _cache = data.map((json) => Course.fromJson(json)).toList();
    return _cache!;
  }
}
