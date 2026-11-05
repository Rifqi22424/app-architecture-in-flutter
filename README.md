# NusaKampus — Sesi 7: Membangun Aplikasi Berskala Besar

Contoh aplikasi untuk mata kuliah **Pemrograman Perangkat Mobile (IF31033)**, Universitas Nusa Putra.

NusaKampus punya tiga tab: **Beranda**, **Jadwal**, dan **Tugas**. Fiturnya sengaja sederhana. Yang dipelajari adalah **cara menyusun kodenya** supaya aplikasi tetap mudah diubah saat fitur dan anggota tim bertambah.

Strukturnya mengikuti panduan arsitektur resmi Flutter: [docs.flutter.dev/app-architecture](https://docs.flutter.dev/app-architecture).

## Menjalankan

```bash
flutter pub get
flutter run
```

Tidak perlu internet: server disimulasikan oleh `CampusService` dengan data contoh dan jeda 0,8 detik.

```bash
flutter test
```

## Empat komponen

| Komponen | Tugas | Contoh di proyek ini |
|---|---|---|
| **View** | Menampilkan data, meneruskan ketukan pengguna | `ui/home/home_screen.dart` |
| **ViewModel** | Mengubah data menjadi isi layar: saring, urutkan, loading, error | `ui/home/home_view_model.dart` |
| **Repository** | Sumber kebenaran: ambil, simpan sementara (cache), ubah menjadi model | `data/repositories/task_repository.dart` |
| **Service** | Berbicara dengan dunia luar (server, database, plugin). Data mentah | `data/services/campus_service.dart` |

Aturannya: View → ViewModel → Repository → Service. Tidak pernah sebaliknya, dan tidak pernah melompat (View tidak boleh memanggil Service).

## Struktur folder

```
lib/
├── main.dart                     # MultiProvider + runApp
├── app.dart                      # MaterialApp + tema
├── config/
│   └── dependencies.dart         # service & repository dibuat sekali di sini
├── domain/
│   └── models/                   # Course, Task (immutable, dipakai semua lapisan)
├── data/                         # disusun PER JENIS
│   ├── services/campus_service.dart
│   └── repositories/
│       ├── schedule_repository.dart
│       └── task_repository.dart  # ChangeNotifier: dipakai Beranda dan Tugas
├── utils/
│   └── date_format.dart
└── ui/                           # disusun PER FITUR
    ├── core/                     # tema + widget bersama (CourseCard, ErrorView)
    ├── shell/app_shell.dart      # NavigationBar, membuat semua ViewModel
    ├── home/                     # view + view_model
    ├── schedule/                 # view + view_model
    └── tasks/                    # view + view_model
test/                             # meniru struktur lib/
├── fakes/fake_campus_service.dart
├── data/
└── ui/
```

## Langkah membangun dari nol

Urutannya dari lapisan paling bawah (data) ke paling atas (layar), supaya setiap lapisan bisa dicek sebelum lapisan di atasnya dibuat.

### Langkah 1 — Folder dan Provider

```bash
flutter create nusa_kampus
cd nusa_kampus
flutter pub add provider
```

Buat folder `config`, `domain/models`, `data/services`, `data/repositories`, dan `ui`.

**Cek:** `flutter analyze` tidak menemukan masalah.

### Langkah 2 — Model

Buat `Course` dan `Task` di `domain/models/`. Semua field `final`, ada `fromJson()`. `Task` punya `copyWith()` karena status `done` bisa berubah.

**Cek:** tidak ada garis merah di editor.

### Langkah 3 — Service

Buat `CampusService` dengan `getSchedule()`, `getTasks()`, dan `updateTask()`. Service mengembalikan `Map` mentah, seperti hasil `jsonDecode` di Sesi 6.

**Cek:** panggil sementara di `main()`:

```dart
CampusService().getTasks().then(print);
```

Konsol mencetak 4 tugas. Hapus lagi baris ini setelah dicek.

### Langkah 4 — Repository

- `ScheduleRepository`: ubah Map menjadi `Course`, simpan di cache.
- `TaskRepository extends ChangeNotifier`: sama, ditambah `setDone()` yang membuat salinan baru dengan `copyWith` lalu memanggil `notifyListeners()`.

**Cek:** `flutter test test/data` → semua test lulus.

### Langkah 5 — ViewModel

Satu ViewModel per layar, semuanya `ChangeNotifier` dengan `isLoading`, `error`, dan `load()`.
`HomeViewModel` mendengarkan `TaskRepository` dengan `addListener(notifyListeners)` dan melepasnya di `dispose()`.

**Cek:** `flutter test test/ui/home_view_model_test.dart` → test "Beranda ikut berubah saat tugas dicentang di fitur lain" lulus.

### Langkah 6 — View, tab, dan Provider

1. Daftarkan service dan repository di `config/dependencies.dart`, lalu bungkus aplikasi dengan `MultiProvider` di `main.dart`.
2. Setiap layar memakai `ListenableBuilder(listenable: viewModel, ...)`.
3. `AppShell` membuat ViewModel dengan `context.read()` dan menampilkan tab dengan `IndexedStack` + `NavigationBar`.

**Cek:** jalankan aplikasi, buka tab Tugas, centang "Laporan praktikum Sesi 6". Badge tab berubah dari 3 menjadi 2, dan Beranda hanya menampilkan 2 tugas.

## Menambah fitur baru (contoh: Pengumuman)

1. Tambah `getAnnouncements()` di `CampusService`.
2. Buat model `Announcement` dan `AnnouncementRepository`.
3. Buat folder `ui/announcements/` berisi `announcements_view_model.dart` dan `announcements_screen.dart`.
4. Daftarkan repository di `config/dependencies.dart` dan tambah satu tab di `AppShell`.

Folder `ui/home/`, `ui/schedule/`, dan `ui/tasks/` tidak perlu disentuh.

## Troubleshooting

| Masalah | Penyebab | Solusi |
|---|---|---|
| `ProviderNotFoundException` | Repository belum didaftarkan, atau urutannya terbalik | Daftarkan di `config/dependencies.dart`; service sebelum repository |
| Layar tidak berubah setelah data berubah | Lupa `notifyListeners()` | Panggil setelah data diubah |
| Beranda dan Tugas berbeda angka | Repository dibuat dua kali (`TaskRepository()` di dalam layar) | Ambil dari Provider dengan `context.read()` |
| Widget memanggil Service langsung | Melompati ViewModel dan Repository | File di `ui/` tidak boleh meng-import `data/services/` |
| `A ... was used after being disposed` | Lupa `removeListener` | Lepas listener di `dispose()` ViewModel |
