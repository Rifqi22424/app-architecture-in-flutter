/// Satu jadwal kuliah dalam seminggu.
///
/// Model ini dipakai oleh lapisan data DAN lapisan UI, karena itu
/// letaknya di folder `domain/`, bukan di dalam salah satu fitur.
class Course {
  final String id;
  final String name;
  final String room;
  final int weekday; // 1 = Senin ... 5 = Jumat (sama dengan DateTime.weekday)
  final String start; // "08:00"
  final String end; // "09:40"

  const Course({
    required this.id,
    required this.name,
    required this.room,
    required this.weekday,
    required this.start,
    required this.end,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      name: json['name'] as String,
      room: json['room'] as String,
      weekday: json['weekday'] as int,
      start: json['start'] as String,
      end: json['end'] as String,
    );
  }
}
