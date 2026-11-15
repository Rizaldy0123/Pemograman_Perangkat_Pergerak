import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'services/auth_api.dart';
import 'services/sesi_memori.dart';

class Modul06App extends StatefulWidget {
  final AuthApi? api;
  final SesiMemori? sesiMemori;

  const Modul06App({super.key, this.api, this.sesiMemori});

  @override
  State<Modul06App> createState() => _Modul06AppState();
}

class _Modul06AppState extends State<Modul06App> {
  // Inisialisasi dilakukan sekali agar penyimpanan sesi (SesiMemori) tetap hidup
  late final AuthApi _api = widget.api ?? AuthApi();
  late final SesiMemori _sesiMemori = widget.sesiMemori ?? SesiMemori();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: LoginScreen(
        api: _api,
        sesiMemori: _sesiMemori,
      ),
    );
  }
}