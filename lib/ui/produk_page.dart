import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProdukForm()),
                ).then((_) => _fetchProduk());
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
                return ItemProduk(
                  produk: _produkList[index],
                  onDelete: _fetchProduk,
                );
              },
            ),
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;
  final VoidCallback onDelete;

  const ItemProduk({Key? key, required this.produk, required this.onDelete})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProdukDetail(produk: produk)),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(produk.namaProduk ?? ''),
          subtitle: Text('Rp. ${produk.hargaProduk?.toString() ?? "0"}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await ProdukBloc.deleteProduk(id: produk.id!);
              onDelete();
            },
          ),
        ),
      ),
    );
  }
}
