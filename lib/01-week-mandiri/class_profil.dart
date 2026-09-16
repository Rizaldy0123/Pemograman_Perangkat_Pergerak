class Profil {
  String nama;
  String nim;
  String? emailKampus;

  Profil({required this.nama, required this.nim, this.emailKampus});

  void tampilkanInfo() {
    print('[$nim] $nama | Email: ${emailKampus ?? '(belum tersedia)'}');
  }
}

void main() {
  Profil profil1 = Profil(
    nim : '362458302001',
    nama : 'Budi Santoso',
    emailKampus : 'budi@poliwangi.ac.id'
  );
  Profil profil2 = Profil(
    nim : '362458302002',
    nama : 'Siti Rahayu',
  );
  profil1.tampilkanInfo();
  profil2.tampilkanInfo();
}