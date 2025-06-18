class Pelanggan {
  int? id;
  String? kodePelanggan;
  String? nama;
  int? totalBelanja;

  Pelanggan({this.id, this.kodePelanggan, this.nama, this.totalBelanja});

  factory Pelanggan.fromJson(Map<String, dynamic> obj) {
    return Pelanggan(
      id: obj['id'],
      // yang perlu diganti
      kodePelanggan: obj['kode_pelanggan'],
      nama: obj['nama'],
      totalBelanja: obj['total_belanja'],
    );
  }
}
