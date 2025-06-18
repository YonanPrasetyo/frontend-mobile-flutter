import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/bloc/logout_bloc.dart';

// ganti nama class
class ProdukPage extends StatefulWidget {
  // ganti
  const ProdukPage({Key? key}) : super(key: key);

  @override
  // ganti
  _ProdukPageState createState() => _ProdukPageState();
}

// ganti nama class
class _ProdukPageState extends State<ProdukPage> {
  // ganti
  List<Produk> _produkList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProduk();
  }

  // ganti nama function
  void _fetchProduk() async {
    try {
      // ganti
      List<Produk> produk = await ProdukBloc.getProduks();
      setState(() {
        // ganti
        _produkList = produk;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // ganti nama function
  void _deleteProduk(int id) async {
    bool confirm = await _showDeleteConfirmationDialog();
    if (!confirm) return;

    try {
      // ganti
      await ProdukBloc.deleteProduk(id: id);
      setState(() {
        // ganti
        _produkList.removeWhere((produk) => produk.id == id);
      });
    } catch (e) {
      // ganti
      _showErrorSnackbar('Gagal menghapus produk');
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            // ganti
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

  // ========== WIDGET TERPISAH UNTUK LIST PRODUK ==========

  // 1. Widget untuk AppBar dengan tombol tambah || INI GANTI
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      // ganti
      title: const Text('List Produk'),
      actions: [_buildAddButton(context)],
    );
  }

  // 2. Widget untuk tombol tambah di AppBar
  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        child: const Icon(Icons.add, size: 26.0),
        onTap: () => _navigateToAddProduct(context),
      ),
    );
  }

  // 3. Widget untuk Drawer
  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          _buildDrawerItem(
            title: 'Logout',
            icon: Icons.logout,
            onTap: () => _handleLogout(),
          ),
          // Bisa tambah menu lain di sini
        ],
      ),
    );
  }

  // 4. Widget untuk item drawer
  ListTile _buildDrawerItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(title: Text(title), trailing: Icon(icon), onTap: onTap);
  }

  // 5. Widget untuk loading state
  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  // 6. Widget untuk empty state (kalau list kosong) || INI GANTI
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            // ganti
            'Belum ada produk',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            // ganti
            'Tap tombol + untuk menambah produk',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // 7. Widget untuk product list || INI GANTI
  Widget _buildProductList() {
    // ganti
    if (_produkList.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      // ganti
      itemCount: _produkList.length,
      // ganti
      itemBuilder: (context, index) => _buildProductItem(_produkList[index]),
    );
  }

  // 8. Widget untuk setiap item produk || INI GANTI (parameter)
  Widget _buildProductItem(Produk produk) {
    return GestureDetector(
      // ganti
      onTap: () => _navigateToProductDetail(produk),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        // ganti
        child: _buildProductTile(produk),
      ),
    );
  }

  // 9. Widget untuk ListTile produk || INI GANTI (parameter)
  ListTile _buildProductTile(Produk produk) {
    return ListTile(
      leading: _buildProductIcon(),
      title: Text(
        // ganti
        produk.namaProduk ?? 'Nama tidak tersedia',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        // ganti
        'Rp. ${_formatHarga(produk.hargaProduk as double?)}',
        style: TextStyle(color: Colors.green[700]),
      ),
      // ganti
      trailing: _buildDeleteButton(produk),
    );
  }

  // 10. Widget untuk icon produk
  Widget _buildProductIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.shopping_bag, color: Colors.blue),
    );
  }

  // 11. Widget untuk tombol delete || INI GANTI (parameter)
  Widget _buildDeleteButton(Produk produk) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      // ganti
      onPressed: () => _showDeleteConfirmation(produk),
    );
  }

  // ========== HELPER METHODS ==========

  // Method untuk format harga
  String _formatHarga(double? harga) {
    if (harga == null) return '0';
    // Bisa ditambah format currency yang lebih bagus
    return harga.toStringAsFixed(0);
  }

  // Method untuk navigasi ke form tambah produk || INI GANTI
  void _navigateToAddProduct(BuildContext context) async {
    await Navigator.push(
      context,
      // ganti
      MaterialPageRoute(builder: (context) => ProdukForm()),
    );
    _fetchProduk();
  }

  // Method untuk navigasi ke detail produk || INI GANTI (parameter)
  void _navigateToProductDetail(Produk produk) {
    Navigator.push(
      context,
      // ganti
      MaterialPageRoute(builder: (context) => ProdukDetail(produk: produk)),
    );
  }

  // Method untuk handle logout
  void _handleLogout() async {
    await LogoutBloc.logout();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  // Method untuk konfirmasi delete || INI GANTI (parameter)
  void _showDeleteConfirmation(Produk produk) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          // ganti
          content: Text('Hapus produk "${produk.namaProduk ?? 'ini'}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // ganti
                _deleteProduk(produk.id!);
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // ========== BUILD METHOD YANG SUDAH CLEAN ==========

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(),
      body: _isLoading ? _buildLoadingState() : _buildProductList(),
    );
  }
}
