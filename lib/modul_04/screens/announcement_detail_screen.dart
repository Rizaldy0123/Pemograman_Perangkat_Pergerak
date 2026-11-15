import 'package:flutter/material.dart';
import '../models/announcement.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  final Announcement announcement;

  const AnnouncementDetailScreen({
    super.key,
    required this.announcement,
  });

  @override
  State<AnnouncementDetailScreen> createState() =>
      _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState
    extends State<AnnouncementDetailScreen> {
  bool _isLoading = false;
  bool _hasError = false;

  void _simulasiMuatUlang() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _pemicuError() {
    setState(() {
      _hasError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Detail Pengumuman'),
        backgroundColor: const Color(0xFF0284C7),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Simulasi Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: _simulasiMuatUlang,
          ),
          IconButton(
            tooltip: 'Simulasi Error',
            icon: const Icon(Icons.bug_report),
            onPressed: _pemicuError,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // 1. STATE 1: LOADING
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF0284C7),
            ),
            SizedBox(height: 16),
            Text(
              'Memuat detail pengumuman...',
              style: TextStyle(
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      );
    }

    // 2. STATE 2: ERROR
    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              const Text(
                'Gagal Memuat Pengumuman',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Terjadi gangguan saat mengambil data pengumuman. '
                'Silakan coba kembali.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _simulasiMuatUlang,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi (Retry)'),
              ),
            ],
          ),
        ),
      );
    }

    // 3. STATE 3: EMPTY
    // State ini digunakan jika data announcement tidak tersedia.
    // Karena widget membutuhkan announcement, kita cek objeknya.
    final announcement = widget.announcement;

    return _buildSuccessState(announcement);
  }

  // 4. STATE 4: SUCCESS
  Widget _buildSuccessState(Announcement announcement) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori dan tanggal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          announcement.category,
                          style: const TextStyle(
                            color: Color(0xFF0284C7),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            announcement.date,
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Judul pengumuman
                  Text(
                    announcement.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Divider(),

                  const SizedBox(height: 16),

                  // Isi pengumuman
                  Text(
                    'Isi Pengumuman',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    announcement.content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF475569),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Tombol kembali
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Pengumuman'),
            ),
          ),
        ],
      ),
    );
  }
}