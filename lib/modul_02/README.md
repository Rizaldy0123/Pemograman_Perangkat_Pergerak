# Laporan Praktikum Modul 02: Declarative UI & Responsive Layout

- **Nama**: [AQILA RIZALDY BINTANG RAMADHAN]
- **NIM**: [362558302074]
- **Kelas / Prodi**: 2A / Sarjana Terapan TRPL
- **Mata Kuliah**: Pemrograman Perangkat Bergerak (Semester 3)

---

## 1. Ringkasan Implementasi
[Jelaskan bagaimana Anda merancang antarmuka pemesanan KopiKita dengan LayoutBuilder responsif, filter kategori Wrap & ChoiceChip, Stack & Positioned untuk badge promo/rating, dan tema Material 3]

## 2. Bukti Tangkapan Layar (Running App)
| Mode Portrait (Light) | Mode Dark Theme | Mode Landscape / Tablet (2 Kolom) |
|---|---|---|
| ![Portrait](./screenshots/Screenshot%202026-09-16%20093043.png) | ![Dark](./screenshots/Screenshot%202026-09-16%20093302.png) | ![Wide](./screenshots/running_tablet_wide.png) |

## 3. Kendala Layout yang Dihadapi & Solusinya
- **Kendala**: [Terjadi ]
- **Solusi**: [Contoh: Membungkus Text dengan Expanded dan menambahkan maxLines: 2 serta TextOverflow.ellipsis]

## 4. Jawaban Pertanyaan Refleksi
1. **Efisiensi Single-pass BoxConstraints**: [Single-pass BoxConstraints membuat proses layout Flutter menjadi lebih efisien karena setiap widget memperoleh batasan ukuran (constraints) dari parent, kemudian menentukan ukuran yang sesuai berdasarkan batasan tersebut dan dilanjutkan ke proses layout. Mekanisme ini membantu Flutter menentukan ukuran dan posisi widget secara terstruktur tanpa melakukan perhitungan layout berulang yang tidak diperlukan. Dengan demikian, proses rendering antarmuka dapat berlangsung lebih konsisten dan efisien.]
2. **Kriteria Modularisasi Widget**: [Widget sebaiknya dimodularisasi ketika memiliki fungsi yang jelas, dapat digunakan kembali, memiliki bagian tampilan yang cukup kompleks, atau memiliki tanggung jawab yang berbeda dari widget utama. Modularisasi membuat kode lebih terstruktur, mudah dibaca, lebih mudah dipelihara, dan mempermudah proses pengembangan ketika suatu bagian UI perlu diperbaiki atau digunakan kembali pada halaman lain.]
3. **Manfaat M3 ThemeData Terpusat**: [Penggunaan ThemeData berdasarkan Material 3 secara terpusat memungkinkan seluruh aplikasi menggunakan sistem desain yang konsisten, seperti warna, tipografi, bentuk komponen, dan gaya widget. Pendekatan ini juga memudahkan perubahan tampilan aplikasi karena pengembang cukup mengubah konfigurasi tema pada satu tempat tanpa harus mengubah setiap widget secara individual. Selain meningkatkan konsistensi UI, pendekatan tersebut juga membuat kode lebih mudah dikelola dan dikembangkan.]