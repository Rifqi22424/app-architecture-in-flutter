import 'package:sesi7_aplikasi_skala_besar/data/services/campus_service.dart';

/// Service palsu untuk test: tanpa jeda, dan bisa dibuat selalu gagal.
class FakeCampusService extends CampusService {
  FakeCampusService({this.fail = false}) : super(delay: Duration.zero);

  bool fail;

  @override
  Future<List<Map<String, dynamic>>> getSchedule() {
    if (fail) throw Exception('server mati');
    return super.getSchedule();
  }

  @override
  Future<List<Map<String, dynamic>>> getTasks() {
    if (fail) throw Exception('server mati');
    return super.getTasks();
  }
}

/// Senin, 9 November 2026: hari dengan 3 jadwal kuliah di data contoh.
DateTime senin() => DateTime(2026, 11, 9);
