import 'package:flutter/material.dart';
import 'screens/task_list_screen.dart';
import 'services/task_storage.dart';

class Modul05App extends StatelessWidget {
  const Modul05App({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan Theme untuk menerapkan warna khusus tanpa memutus navigasi
    return Theme(
      data: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      // Jika TaskStorage() di bawah ini bergaris merah, 
      // coba tambahkan atau hapus kata 'const' di depannya sesuai kebutuhan file Anda.
      child: const TaskListScreen(storage: TaskStorage()),
    );
  }
}