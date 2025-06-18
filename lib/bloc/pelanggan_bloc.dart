import 'dart:convert';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/model/pelanggan.dart';

class PelangganBloc {
  // ganti nama fungsi
  static Future<List<Pelanggan>> getPelanggans() async {
    try {
      // ganti
      String apiUrl = ApiUrl.listPelanggan;

      var response = await Api().get(apiUrl);
      var jsonObj = json.decode(response.body);

      // ganti
      List<dynamic> listPelanggan = (jsonObj as Map<String, dynamic>)['data'];
      // ganti (s)
      List<Pelanggan> pelanggans = [];
      // ganti
      for (int i = 0; i < listPelanggan.length; i++) {
        // ganti (s)
        pelanggans.add(Pelanggan.fromJson(listPelanggan[i]));
      }
      // ganti
      return pelanggans;
    } catch (e) {
      print('PelangganBloc error: $e');
      rethrow;
    }
  }

  // ganti nama fungsi dan parameter
  static Future addPelanggan({Pelanggan? pelanggan}) async {
    try {
      // ganti
      String apiUrl = ApiUrl.createPelanggan;

      // sesuaikan
      var body = {
        "kode_pelanggan": pelanggan!.kodePelanggan,
        "nama": pelanggan.nama,
        // kalau angka
        "total_belanja": pelanggan.totalBelanja.toString(),
      };

      var response = await Api().post(apiUrl, body);
      var jsonObj = json.decode(response.body);
      return jsonObj['success'];
    } catch (e) {
      // ganti
      print('PelangganBlocAdd error: $e');
      rethrow;
    }
  }

  // ganti nama fungsi dan parameter
  static Future<bool> updatePelanggan({required Pelanggan pelanggan}) async {
    try {
      // ganti
      String apiUrl = ApiUrl.updatePelanggan(pelanggan.id!);

      // sesuaikan
      var body = {
        "kode_pelanggan": pelanggan.kodePelanggan,
        "nama": pelanggan.nama,
        // kalau angka
        "total_belanja": pelanggan.totalBelanja.toString(),
      };
      print("Body : $body");
      var response = await Api().put(apiUrl, body);
      var jsonObj = json.decode(response.body);
      return jsonObj['success'];
    } catch (e) {
      // ganti
      print('PelangganBlockUpdate error: $e');
      rethrow;
    }
  }

  // ganti nama fungsi
  static Future<bool> deletePelanggan({required int id}) async {
    try {
      // ganti
      String apiUrl = ApiUrl.deletePelanggan(id);

      var response = await Api().delete(apiUrl);
      var jsonObj = json.decode(response.body);
      return jsonObj['success'] == true;
    } catch (e) {
      // ganti
      print('PelangganBlocDelete error: $e');
      return false;
    }
  }
}
