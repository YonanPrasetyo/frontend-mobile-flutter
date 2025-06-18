import 'dart:convert';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/model/produk.dart';

class ProdukBloc {
  // ganti nama fungsi
  static Future<List<Produk>> getProduks() async {
    try {
      // ganti
      String apiUrl = ApiUrl.listProduk;

      var response = await Api().get(apiUrl);
      var jsonObj = json.decode(response.body);

      // ganti
      List<dynamic> listProduk = (jsonObj as Map<String, dynamic>)['data'];
      // ganti (s)
      List<Produk> produks = [];
      // ganti
      for (int i = 0; i < listProduk.length; i++) {
        // ganti (s)
        produks.add(Produk.fromJson(listProduk[i]));
      }
      // ganti
      return produks;
    } catch (e) {
      print('ProdukBloc error: $e');
      rethrow;
    }
  }

  // ganti nama fungsi dan parameter 
  static Future addProduk({Produk? produk}) async {
    try {
      // ganti
      String apiUrl = ApiUrl.createProduk;

      // sesuaikan
      var body = {
        "kode_produk": produk!.kodeProduk,
        "nama_produk": produk.namaProduk,
        // kalau angka
        "harga": produk.hargaProduk.toString(),
      };

      var response = await Api().post(apiUrl, body);
      var jsonObj = json.decode(response.body);
      return jsonObj['success'];
    } catch (e) {
      // ganti
      print('ProdukBlocAdd error: $e');
      rethrow;
    }
  }

 // ganti nama fungsi dan parameter
  static Future<bool> updateProduk({required Produk produk}) async {
    try {
      // ganti
      String apiUrl = ApiUrl.updateProduk(produk.id!);

      // sesuaikan
      var body = {
        "kode_produk": produk.kodeProduk,
        "nama_produk": produk.namaProduk,
        // kalau angka
        "harga": produk.hargaProduk.toString(),
      };
      print("Body : $body");
      var response = await Api().put(apiUrl, body);
      var jsonObj = json.decode(response.body);
      return jsonObj['success'];
    } catch (e) {
      // ganti
      print('ProdukBlockUpdate error: $e');
      rethrow;
    }
  }

  // ganti nama fungsi
  static Future<bool> deleteProduk({required int id}) async {
    try {
      // ganti
      String apiUrl = ApiUrl.deleteProduk(id);

      var response = await Api().delete(apiUrl);
      var jsonObj = json.decode(response.body);
      return jsonObj['success'] == true;
    } catch (e) {
      // ganti
      print('ProdukBlocDelete error: $e');
      return false;
    }
  }
}
