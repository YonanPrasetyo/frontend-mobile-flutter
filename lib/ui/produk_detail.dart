import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import './produk_form.dart';

class ProdukDetail extends StatefulWidget {
  final Produk? produk;

  ProdukDetail({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: widget.produk == null
          ? const Center(child: Text("Produk tidak tersedia"))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Kode : ${widget.produk!.kodeProduk}",
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    "Nama : ${widget.produk!.namaProduk}",
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    "Harga : Rp. ${widget.produk!.hargaProduk.toString()}",
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20),
                  _tombolHapusEdit(),
                ],
              ),
            ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () {
            if (widget.produk != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProdukForm(produk: widget.produk!),
                ),
              );
            }
          },
        ),
        const SizedBox(width: 10),
        // Tombol Hapus
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text("Yakin ingin menghapus data ini?"),
          actions: [
            // Tombol Hapus
            OutlinedButton(
              child: const Text("Ya"),
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Produk berhasil dihapus")),
                );
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
            ),
            // Tombol Batal
            OutlinedButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
