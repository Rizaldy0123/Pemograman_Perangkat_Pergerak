import 'package:flutter/material.dart';
import 'modul_02/academic_dashboard_screen.dart';


void main(List<String> args) {
  runApp(const MyApp());
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
          seedColor:  Color(0xFF0284C7),
          brightness: Brightness.light,
        ),
      ),
      home: const AcademicDashboardScreen(),
    );
  }
}
class HomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(title: Text('TRPL 2A Dashboard'),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Halo, Selamat Datang di Dashboard Akademik TRPL 2A!'),
          Text('Kami dari kelas 2ATRPL')
        ]
      )
    );
  }
}
