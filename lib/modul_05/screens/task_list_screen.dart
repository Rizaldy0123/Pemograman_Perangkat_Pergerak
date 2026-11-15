import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_storage.dart';
import '../widgets/task_tile.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key, this.storage});

  /// Dapat disuntikkan dari luar (widget test atau praktikum keadaan memuat).
  final TaskStorage? storage;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late final TaskStorage _storage = widget.storage ?? const TaskStorage();

  List<Task>? _tugas;
  Object? _error;
  bool _sedangMenyimpan = false;

  @override
  void initState() {
    super.initState();
    unawaited(_muat());
  }

  bool _nilaiSelesai(Task task) {
    final dynamic item = task;
    try {
      return (item.isDone as bool?) ?? false;
    } catch (_) {
      try {
        return (item.done as bool?) ?? false;
      } catch (_) {
        final dynamic json = item.toJson?.call();
        if (json is Map) {
          return (json['isDone'] as bool?) ?? (json['done'] as bool?) ?? false;
        }
        return false;
      }
    }
  }

  void _aturSelesai(Task task, bool selesai) {
    final dynamic item = task;
    try {
      item.isDone = selesai;
      return;
    } catch (_) {
      try {
        item.done = selesai;
        return;
      } catch (_) {
        final dynamic json = item.toJson?.call();
        if (json is Map) {
          json['isDone'] = selesai;
          json['done'] = selesai;
        }
      }
    }
  }

  Future<void> _muat() async {
    try {
      final dynamic storage = _storage;
      final dynamic data = await (
            storage.load?.call() ??
            storage.loadTasks?.call() ??
            storage.read?.call() ??
            storage.readTasks?.call()
          );

      final List<Task> tugas = (data as List<Task>? ?? const <Task>[]);
      if (!mounted) return;
      setState(() {
        _tugas = tugas;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _tugas = const <Task>[];
      });
      _pesan(_apikanPesan(e));
    }
  }

  Future<void> _simpan() async {
    if (_tugas == null) return;
    if (mounted) {
      setState(() {
        _sedangMenyimpan = true;
      });
    }
    try {
      final dynamic storage = _storage;
      await (
            storage.save?.call(_tugas!) ??
            storage.saveTasks?.call(_tugas!) ??
            storage.write?.call(_tugas!) ??
            storage.writeTasks?.call(_tugas!)
          );
    } finally {
      if (mounted) {
        setState(() {
          _sedangMenyimpan = false;
        });
      }
    }
  }

  void _pesan(String teks) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(teks)),
    );
  }

  String _apikanPesan(Object e) {
    if (e is FormatException) return 'Format data tersimpan rusak.';
    final String teks = e.toString();
    return teks.startsWith('Exception: ') ? teks.substring('Exception: '.length) : teks;
  }

  Future<void> _ubahStatus(Task task) async {
    final bool sebelumnya = _nilaiSelesai(task);
    _aturSelesai(task, !sebelumnya);

    setState(() {});

    try {
      await _simpan();
    } catch (e) {
      if (!mounted) return;
      _aturSelesai(task, sebelumnya);
      _pesan(_apikanPesan(e));
    }
  }

  // --- PEMBARUAN PADA BAGIAN TAMPILAN (BUILD) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar diperlukan agar layar tidak "gundul" dan tombol kembali (back) muncul.
      appBar: AppBar(
        title: const Text('Manajemen Tugas (Lokal)'),
      ),
      // Logika diubah: tangani 3 kondisi (sedang memuat, data kosong, atau ada data)
      body: _tugas == null
          ? _tampilanMemuat()
          : _tugas!.isEmpty
              ? _tampilanKosong()
              : _tampilanDaftar(_tugas!),
      
      // Anda bisa biarkan ini jika ingin menambahkan fitur "Tambah Tugas" nanti
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _pesan('Fitur tambah tugas belum tersedia.');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Tampilan ketika daftar tugas sama sekali tidak ada (kosong)
  Widget _tampilanKosong() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Belum ada tugas yang tersimpan.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _tampilanDaftar(List<Task> tugas) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: tugas.length,
      itemBuilder: (BuildContext context, int i) {
        final Task t = tugas[i];
        return TaskTile(
          task: t,
          onToggle: (dynamic task) {
            unawaited(_ubahStatus(task as Task));
          },
        );
      },
    );
  }

  Widget _tampilanMemuat() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Memuat tugas dari penyimpanan...'),
        ],
      ),
    );
  }
}