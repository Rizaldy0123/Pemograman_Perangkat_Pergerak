double hitungLuasPersegiPanjang(double panjang, double lebar) {
  return panjang * lebar;
}

void main() {
  double nilaiPanjang = 7.1;
  double nilaiLebar = 5.0;

  double hasilLuas = hitungLuasPersegiPanjang(nilaiPanjang, nilaiLebar);

  print('Luas: ${hasilLuas.toStringAsFixed(2)} cm²');
}