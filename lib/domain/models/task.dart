/// Satu tugas kuliah.
///
/// Semua field `final` (immutable): objek tidak bisa diubah setelah dibuat.
/// Untuk "mengubah" tugas, buat salinan baru dengan [copyWith].
class Task {
  final String id;
  final String title;
  final String courseName;
  final DateTime due;
  final bool done;

  const Task({
    required this.id,
    required this.title,
    required this.courseName,
    required this.due,
    this.done = false,
  });

  Task copyWith({bool? done}) {
    return Task(
      id: id,
      title: title,
      courseName: courseName,
      due: due,
      done: done ?? this.done,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      courseName: json['courseName'] as String,
      due: DateTime.parse(json['due'] as String),
      done: json['done'] as bool,
    );
  }
}
