import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import './produk_form.dart';

// ganti nama class
class ProdukDetail extends StatefulWidget {
  // ganti
  final Produk? produk;

  // ganti
  ProdukDetail({Key? key, this.produk}) : super(key: key);

  @override
  // ganti
  _ProdukDetailState createState() => _ProdukDetailState();
}

// ganti nama class
class _ProdukDetailState extends State<ProdukDetail> {
  // ganti nama fungsi dan parameter
  Widget _buildProductCard(Produk produk) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // isi children cuma manggil function _buildDetailRow per data yang ingin ditampilkan
            _buildDetailRow(
              icon: Icons.qr_code,
              // ganti
              label: "Kode Produk",
              // ganti
              value: produk.kodeProduk,
              fontSize: 20.0,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.shopping_bag,
              // ganti
              label: "Nama Produk",
              // ganti
              value: produk.namaProduk,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.attach_money,
              // ganti
              label: "Harga",
              // ganti (contoh untuk nilai integer)
              value: produk.hargaProduk != null
                  ? "Rp. ${produk.hargaProduk.toString()}"
                  : null, // Handle null harga
            ),
            const SizedBox(height: 20),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  // ini fungsi template tinggal copas
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String? value,
    double fontSize = 18.0,
  }) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value ?? 'Tidak tersedia',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: value == null ? Colors.grey : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ini fungsi template tinggal copas
  Widget _buildEmptyState() {
    return const Center(child: Text("Produk tidak tersedia"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ganti
      appBar: AppBar(title: const Text('Detail Produk')),
      body: widget.produk == null
          ? _buildEmptyState()
          // ganti
          : SingleChildScrollView(child: _buildProductCard(widget.produk!)),
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
            // ganti
            if (widget.produk != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // ganti
                  builder: (context) => ProdukForm(produk: widget.produk!),
                ),
              );
            }
          },
        ),
        const SizedBox(width: 10),
        // Tombol Hapus
        /* OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ) */
      ],
    );
  }

  /* void confirmHapus() {
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
  } */
}
