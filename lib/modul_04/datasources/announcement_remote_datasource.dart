import 'package:dio/dio.dart';
import '../models/announcement.dart';

class AnnouncementRemoteDataSource {
  final Dio _dio;

  AnnouncementRemoteDataSource({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://jsonplaceholder.typicode.com',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                headers: {'Accept': 'application/json'},
              ),
            ) {
    // Logging interceptor untuk memantau request di terminal
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  // Dipetakan 1:1 dengan urutan data dari API, supaya HTTP request tetap asli
  // tapi konten yang ditampilkan relevan dengan konteks akademik.
  static const List<Map<String, String>> _kampusContent = [
    {
      'title': 'Jadwal Pengisian KRS Semester Ganjil 2026/2027',
      'content':
          'Pengisian Kartu Rencana Studi (KRS) untuk seluruh mahasiswa Sarjana Terapan TRPL Semester Ganjil 2026/2027 dimulai tanggal 1 hingga 7 September 2026 secara mandiri melalui SIAKAD. Pastikan telah berkonsultasi dengan Dosen Pembimbing Akademik sebelum melakukan finalisasi.',
    },
    {
      'title': 'Pendaftaran Beasiswa PPA dan BBM Tahun 2026',
      'content':
          'Dibuka pendaftaran Beasiswa Peningkatan Prestasi Akademik (PPA) dan Bantuan Belajar Mahasiswa (BBM) bagi mahasiswa aktif dengan IPK minimal 3.00. Berkas dikumpulkan paling lambat 15 September 2026 ke bagian Kemahasiswaan.',
    },
    {
      'title': 'Kegiatan Pengabdian Masyarakat Mahasiswa TRPL',
      'content':
          'Program pengabdian masyarakat berupa pelatihan digitalisasi UMKM akan dilaksanakan di Desa Kembiritan pada 20-22 September 2026. Mahasiswa semester 5 wajib mengikuti sebagai bagian dari mata kuliah KKN.',
    },
    {
      'title': 'Mahasiswa TRPL Raih Juara Nasional Hackathon',
      'content':
          'Tim mahasiswa TRPL berhasil meraih Juara 1 pada ajang National Hackathon 2026 dengan mengembangkan aplikasi manajemen sampah berbasis IoT. Selamat kepada seluruh anggota tim atas prestasi membanggakan ini.',
    },
    {
      'title': 'Pendaftaran Magang Industri Bersertifikat Batch 7',
      'content':
          'Kesempatan magang 6 bulan di perusahaan teknologi mitra jurusan untuk mahasiswa semester 5. Peserta akan mendapatkan sertifikat industri dan konversi 20 SKS. Pendaftaran dibuka hingga 25 September 2026.',
    },
    {
      'title': 'Sosialisasi Beasiswa Unggulan Kemendikbud',
      'content':
          'Bagian Kemahasiswaan mengundang seluruh mahasiswa untuk mengikuti sosialisasi Beasiswa Unggulan yang akan diselenggarakan secara daring pada 18 September 2026 pukul 09.00 WIB.',
    },
    {
      'title': 'Jadwal Ujian Tengah Semester Ganjil 2026/2027',
      'content':
          'Ujian Tengah Semester (UTS) akan dilaksanakan pada 6-17 Oktober 2026 sesuai jadwal mata kuliah masing-masing. Mahasiswa wajib membawa Kartu Ujian yang dapat dicetak melalui SIAKAD.',
    },
    {
      'title': 'Workshop Pengembangan Aplikasi Mobile Flutter',
      'content':
          'Himpunan Mahasiswa TRPL mengadakan workshop pengembangan aplikasi mobile menggunakan Flutter pada 12 September 2026 bertempat di Lab Pemrograman. Pendaftaran gratis bagi seluruh mahasiswa TRPL.',
    },
    {
      'title': 'Pengumuman Yudisium Periode September 2026',
      'content':
          'Bagi mahasiswa yang telah menyelesaikan seluruh persyaratan akademik, pelaksanaan yudisium periode September 2026 akan dilaksanakan pada 30 September 2026. Informasi lebih lanjut dapat dilihat di papan pengumuman jurusan.',
    },
    {
      'title': 'Lomba Karya Tulis Ilmiah Tingkat Jurusan',
      'content':
          'Dalam rangka memperingati Dies Natalis Poliwangi, jurusan TRPL mengadakan Lomba Karya Tulis Ilmiah dengan tema teknologi berkelanjutan. Pendaftaran dan pengumpulan naskah paling lambat 28 September 2026.',
    },
  ];

  // Mengambil daftar pengumuman dari server
  Future<List<Announcement>> fetchAnnouncements() async {
    final response = await _dio.get('/posts');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data as List<dynamic>;
      final categories = ['Akademik', 'Beasiswa', 'Kegiatan', 'Prestasi'];

      return data.take(10).toList().asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value as Map<String, dynamic>;

        final kampusItem = index < _kampusContent.length
            ? _kampusContent[index]
            : null;

        return Announcement(
          id: item['id'] as int? ?? (index + 1),
          title: kampusItem?['title'] ??
              (item['title'] as String? ?? 'Pengumuman Kampus'),
          content: kampusItem?['content'] ??
              (item['body'] as String? ?? 'Konten pengumuman akademik.'),
          author: 'Bagian Akademik Poliwangi',
          category: categories[index % categories.length],
          date: '2026-09-${(index % 28 + 1).toString().padLeft(2, '0')}',
          readCount: (index + 1) * 37,
        );
      }).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Gagal mengambil data dari server',
      );
    }
  }

  // Mengirim pengumuman baru (HTTP POST)
  Future<Announcement> createAnnouncement(Announcement announcement) async {
    try {
      final response = await _dio.post('/posts', data: announcement.toJson());
      if (response.statusCode == 201 || response.statusCode == 200) {
        return announcement;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Gagal membuat pengumuman baru',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}