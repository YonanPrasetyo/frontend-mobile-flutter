class ApiUrl {
  static const String baseUrl = 'http://localhost:8080/api';

  // sesuaikan dengan end point API
  static const String registrasi = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';


  // produk
  static const String listProduk = '$baseUrl/produk';
  static const String createProduk = '$baseUrl/produk';

  static String updateProduk(int id) {
    return '$baseUrl/produk/$id/update';
  }

  static String showProduk(int id) {
    return '$baseUrl/produk/$id';
  }

  static String deleteProduk(int id) {
    return '$baseUrl/produk/$id';
  }

  //pelanggan
  static const String listPelanggan = '$baseUrl/pelanggan';
  static const String createPelanggan = '$baseUrl/pelanggan';

  static String updatePelanggan(int id) {
    return '$baseUrl/pelanggan/$id/update';
  }

  static String showPelanggan(int id) {
    return '$baseUrl/pelanggan/$id';
  }

  static String deletePelanggan(int id) {
    return '$baseUrl/pelanggan/$id';
  }
}
