import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/bloc/logout_bloc.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({Key? key}) : super(key: key);

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  List<Produk> _produkList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProduk();
  }

  void _fetchProduk() async {
    try {
      List<Produk> produk = await ProdukBloc.getProduks();
      setState(() {
        _produkList = produk;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _deleteProduk(int id) async {
    bool confirm = await _showDeleteConfirmationDialog();
    if (!confirm) return;

    try {
      await ProdukBloc.deleteProduk(id: id);
      setState(() {
        _produkList.removeWhere((produk) => produk.id == id);
      });
    } catch (e) {
      _showErrorSnackbar('Gagal menghapus produk');
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Yakin ingin menghapus produk ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProdukForm()),
                );
                _fetchProduk();
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {},
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _produkList.length,
              itemBuilder: (context, index) {
                final produk = _produkList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProdukDetail(produk: produk),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(produk.namaProduk ?? ''),
                      subtitle: Text(
                        'Rp. ${produk.hargaProduk?.toString() ?? "0"}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProduk(produk.id!),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
