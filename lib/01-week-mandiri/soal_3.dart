void main() {
  double luas = hitungLuasPersegiPanjang(7.1, 5.0);
  print('Luas: ${luas.toStringAsFixed(2)} cm²\n');

  Profil profil1 = Profil(
    nim: '362458302001',
    nama: 'Budi Santoso',
    emailKampus: 'budi@poliwangi.ac.id'
  );

  Profil profil2 = Profil(
    nim: '362458302002',
    nama: 'Siti Rahayu'
  );

  profil1.tampilkanInfo();
  profil2.tampilkanInfo();

  print('\nPanjang karakter email profil1: ${profil1.emailKampus?.length}');
  
  print('Panjang karakter email profil2: ${profil2.emailKampus?.length}'); 
}

double hitungLuasPersegiPanjang(double panjang, double lebar) {
  return panjang * lebar;
}

class Profil {
  String nama;
  String nim;
  String? emailKampus;

  Profil({required this.nama, required this.nim, this.emailKampus});

  void tampilkanInfo() {
    print('[$nim] $nama | Email: ${emailKampus ?? '(belum ada email)'}');
  }
}