import 'package:flutter/material.dart';
import '../models/sesi_pengguna.dart';

class KartuSesi extends StatelessWidget {
  final SesiPengguna sesi;
  final DateTime sekarang;
  final VoidCallback? onKeluar;
  final bool sedangKeluar;
  final bool tampilkanToken;

  const KartuSesi({
    super.key,
    required this.sesi,
    required this.sekarang,
    this.onKeluar,
    this.sedangKeluar = false,
    this.tampilkanToken = false,
  });

  @override
  Widget build(BuildContext context) {
    final String tokenAman = tampilkanToken || sesi.token.length <= 8
        ? sesi.token
        : '••••••••${sesi.token.substring(sesi.token.length - 4)}';

    // Ekstraksi field dinamis untuk mengantisipasi perbedaan versi model SesiPengguna
    final dynamic dataSesi = sesi; 
    
    String nama = 'Tidak diketahui';
    String email = 'Tidak diketahui';
    String peran = 'Tidak diketahui';
    String waktuMasuk = 'Tidak diketahui';
    String sisaWaktu = 'Tidak diketahui';

    try { nama = dataSesi.nama ?? '-'; } catch (_) {}
    try { email = dataSesi.email ?? '-'; } catch (_) {}
    try { peran = dataSesi.peran ?? dataSesi.labelPeran ?? '-'; } catch (_) {}
    try { 
      waktuMasuk = dataSesi.waktuMasuk != null 
          ? dataSesi.waktuMasuk.toString() 
          : dataSesi.formatWaktu ?? '-'; 
    } catch (_) {}
    
    try {
      if (dataSesi.batasKedaluwarsa != null) {
        final selisih = (dataSesi.batasKedaluwarsa as DateTime).difference(sekarang);
        sisaWaktu = '${selisih.inMinutes} menit';
      } else if (dataSesi.formatSisa != null) {
        sisaWaktu = dataSesi.formatSisa;
      }
    } catch (_) {}

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Text(
                'Informasi Sesi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 24),
            _InfoRow(label: 'Nama', nilai: nama),
            _InfoRow(label: 'Email', nilai: email),
            _InfoRow(label: 'Peran', nilai: peran),
            _InfoRow(label: 'Waktu Masuk', nilai: waktuMasuk),
            _InfoRow(label: 'Sisa Waktu', nilai: sisaWaktu),
            _InfoRow(label: 'Token', nilai: tokenAman),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: sedangKeluar ? null : onKeluar,
                icon: sedangKeluar 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.logout),
                label: const Text('Keluar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String nilai;

  const _InfoRow({required this.label, required this.nilai});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          const Text(': '),
          Expanded(child: Text(nilai)),
        ],
      ),
    );
  }
}