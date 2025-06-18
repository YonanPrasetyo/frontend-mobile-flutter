import 'dart:convert';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/model/produk.dart';

class ProdukBloc {
  static Future<List<Produk>> getProduks() async {
    try {
      String apiUrl = ApiUrl.listProduk;

      var response = await Api().get(apiUrl);
      var jsonObj = json.decode(response.body);

      List<dynamic> listProduk = (jsonObj as Map<String, dynamic>)['data'];
      List<Produk> produks = [];
      for (int i = 0; i < listProduk.length; i++) {
        produks.add(Produk.fromJson(listProduk[i]));
      }
      return produks;
    } catch (e) {
      print('ProdukBloc error: $e');
      rethrow;
    }
  }

  static Future addProduk({Produk? produk}) async {
    try {
      String apiUrl = ApiUrl.createProduk;

      var body = {
        "kode_produk": produk!.kodeProduk,
        "nama_produk": produk.namaProduk,
        "harga": produk.hargaProduk.toString(),
      };

      var response = await Api().post(apiUrl, body);
      var jsonObj = json.decode(response.body);
      return jsonObj['success'];
    } catch (e) {
      print('ProdukBlocAdd error: $e');
      rethrow;
    }
  }

  static Future<bool> updateProduk({required Produk produk}) async {
    try {
      String apiUrl = ApiUrl.updateProduk(produk.id!);

      var body = {
        "kode_produk": produk.kodeProduk,
        "nama_produk": produk.namaProduk,
        "harga": produk.hargaProduk.toString(),
      };
      print("Body : $body");
      var response = await Api().put(apiUrl, body);
      var jsonObj = json.decode(response.body);
      return jsonObj['success'];
    } catch (e) {
      print('ProdukBlockUpdate error: $e');
      rethrow;
    }
  }

  static Future<bool> deleteProduk({required int id}) async {
    try {
      String apiUrl = ApiUrl.deleteProduk(id);
      var response = await Api().delete(apiUrl);
      var jsonObj = json.decode(response.body);
      return jsonObj['success'] == true;
    } catch (e) {
      print('ProdukBlocDelete error: $e');
      return false;
    }
  }
}
