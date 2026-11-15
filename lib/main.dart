import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'modul_02/academic_dashboard_screen.dart';
import 'modul_03/modul_03_app.dart';
import 'modul_04/screens/announcement_list_screen.dart';
import 'modul_05/modul_05_app.dart';
import 'modul_06/modul_06__app.dart';

void main(List<String> args) {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Dashboard Akademik TRPL',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0284C7),
          brightness: Brightness.light,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Akademik TRPL")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Halo, Mahasiswa TRPL 2A!"),
            const Text("Selamat datang di aplikasi dashboard akademik."),
            const SizedBox(height: 24),
            
            // --- Modul 02 ---
            Card(
              child: ListTile(
                title: const Text("Modul 02"),
                subtitle: const Text("Dashboard Akademik (Declarative UI)"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AcademicDashboardScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            
            // --- Modul 03 ---
            Card(
              child: ListTile(
                title: const Text("Modul 03"),
                subtitle: const Text("KRS & State Management (Riverpod)"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Modul03App()),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            
            // --- Modul 04 ---
            Card(
              child: ListTile(
                title: const Text("Modul 04"),
                subtitle: const Text("Portal Pengumuman (REST API & Async)"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AnnouncementListScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // --- Modul 05 ---
            Card(
              child: ListTile(
                title: const Text("Modul 05"),
                subtitle: const Text("Manajemen Tugas (Lokal)"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Modul05App(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // --- Modul 06 ---
            Card(
              child: ListTile(
                title: const Text("Modul 06"),
                subtitle: const Text("Autentikasi & Sesi Pengguna"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Modul06App(), // <-- Memanggil Modul06App
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}