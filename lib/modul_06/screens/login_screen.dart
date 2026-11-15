import 'package:flutter/material.dart';
import '../services/auth_api.dart';
import '../services/sesi_memori.dart';
import '../models/sesi_pengguna.dart';
import '../widgets/kartu_sesi.dart'; // Import ini sudah diaktifkan

extension SesiPenggunaEkstensi on SesiPengguna {
  bool sudahKedaluwarsa(DateTime waktuSekarang) {
    final dynamic sesi = this;
    final DateTime? waktuBerakhir = sesi.kedaluwarsaPada is DateTime
        ? sesi.kedaluwarsaPada as DateTime
        : sesi.kadaluarsaPada is DateTime
            ? sesi.kadaluarsaPada as DateTime
            : sesi.berakhirPada is DateTime
                ? sesi.berakhirPada as DateTime
                : sesi.expiredAt is DateTime
                    ? sesi.expiredAt as DateTime
                    : null;

    return waktuBerakhir != null && waktuSekarang.isAfter(waktuBerakhir);
  }
}

// --- LANGKAH 6: Definisi Keadaan ---
enum StatusAuth { memeriksa, keluar, memproses, masuk, gagal }

class LoginScreen extends StatefulWidget {
  final AuthApi api;
  final SesiMemori sesiMemori;
  final DateTime Function() jam;

  const LoginScreen({
    super.key,
    required this.api,
    required this.sesiMemori,
    this.jam = DateTime.now,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _sandi = TextEditingController();

  StatusAuth _status = StatusAuth.memeriksa;
  String? _pesanGagal;
  SesiPengguna? _sesi;
  bool _sedangKeluar = false;

  @override
  void initState() {
    super.initState();
    _pulihkanSesi();
  }

  // --- LANGKAH 9: Pembersihan Controller ---
  @override
  void dispose() {
    _email.dispose();
    _sandi.dispose();
    super.dispose();
  }

  // --- LANGKAH 7: Pulihkan Sesi ---
  Future<void> _pulihkanSesi() async {
    final SesiPengguna? tersimpan = widget.sesiMemori.baca();
    
    if (!mounted) return;

    if (tersimpan == null) {
      setState(() => _status = StatusAuth.keluar);
      return;
    }

    if (tersimpan.sudahKedaluwarsa(widget.jam())) {
      await widget.sesiMemori.hapus();
      if (!mounted) return;
      setState(() {
        _status = StatusAuth.gagal;
        _pesanGagal = 'Sesi sebelumnya sudah berakhir. Silakan masuk lagi.';
      });
      return;
    }

    // Jika sesi valid, otomatis masuk
    setState(() {
      _sesi = tersimpan;
      _status = StatusAuth.masuk;
    });
  }

  // --- LANGKAH 8: Handler Login ---
  Future<void> _kirim() async {
    if (_status == StatusAuth.memproses) return; // Cegah kirim ganda.
    
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _status = StatusAuth.memproses;
      _pesanGagal = null;
    });

    try {
      final SesiPengguna hasil = await widget.api.masuk(
        email: _email.text,
        sandi: _sandi.text,
      );

      await widget.sesiMemori.simpan(hasil);
      
      if (!mounted) return;

      setState(() {
        _sesi = hasil;
        _status = StatusAuth.masuk;
      });
      
      _sandi.clear(); // Bersihkan sandi setelah berhasil
      
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _status = StatusAuth.gagal;
        _pesanGagal = e.pesan; 
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = StatusAuth.gagal;
        _pesanGagal = 'Terjadi kesalahan sistem. Coba lagi nanti.';
      });
    }
  }

  // --- LANGKAH 10: Handler Keluar ---
  Future<void> _keluar() async {
    setState(() => _sedangKeluar = true);
    await widget.sesiMemori.hapus();
    
    if (!mounted) return;
    
    setState(() {
      _sesi = null;
      _status = StatusAuth.keluar; // Bukan StatusAuth.gagal
      _pesanGagal = null;
      _sedangKeluar = false;
      _email.clear();
      _sandi.clear();
    });
  }

  // --- Tampilan: Form Login ---
  Widget _bangunForm() {
    final bool sibuk = _status == StatusAuth.memproses;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        const SizedBox(height: 8),
        const Text(
          'Masuk ke Portal Akademik',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        if (_pesanGagal != null) ...<Widget>[
          Container(
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.errorContainer,
            child: Text(
              _pesanGagal!,
              style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
            ),
          ),
          const SizedBox(height: 16),
        ],

        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                enabled: !sibuk,
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sandi,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Kata Sandi',
                  border: OutlineInputBorder(),
                ),
                enabled: !sibuk,
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: sibuk ? null : _kirim,
                  child: sibuk
                      ? const CircularProgressIndicator()
                      : const Text('Masuk'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Tampilan: Halaman Masuk (Beranda Sesi) yang sudah diperbarui ---
  Widget _bangunBeranda() {
    return Center(
      child: SingleChildScrollView(
        child: KartuSesi(
          sesi: _sesi!,
          sekarang: widget.jam(),
          onKeluar: _keluar,
          sedangKeluar: _sedangKeluar,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Autentikasi')),
      body: _status == StatusAuth.memeriksa
          ? const Center(child: CircularProgressIndicator())
          : _status == StatusAuth.masuk
              ? _bangunBeranda()
              : _bangunForm(),
    );
  }
}