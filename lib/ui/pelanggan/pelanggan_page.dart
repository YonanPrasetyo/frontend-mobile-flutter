import 'package:flutter/material.dart';
import 'package:tokokita/bloc/pelanggan_bloc.dart';
import 'package:tokokita/model/pelanggan.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/pelanggan/pelanggan_detail.dart';
import 'package:tokokita/ui/pelanggan/pelanggan_form.dart';
import 'package:tokokita/bloc/logout_bloc.dart';
import 'package:tokokita/ui/produk/produk_page.dart';

// ganti nama class
class PelangganPage extends StatefulWidget {
  // ganti
  const PelangganPage({Key? key}) : super(key: key);

  @override
  // ganti
  _PelangganPageState createState() => _PelangganPageState();
}

// ganti nama class
class _PelangganPageState extends State<PelangganPage> {
  // ganti
  List<Pelanggan> _pelangganList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPelanggan();
  }

  // ganti nama function
  void _fetchPelanggan() async {
    try {
      // ganti
      List<Pelanggan> pelanggan = await PelangganBloc.getPelanggans();
      setState(() {
        // ganti
        _pelangganList = pelanggan;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // ganti nama function
  void _deletePelanggan(int id) async {
    bool confirm = await _showDeleteConfirmationDialog();
    if (!confirm) return;

    try {
      // ganti
      await PelangganBloc.deletePelanggan(id: id);
      setState(() {
        // ganti
        _pelangganList.removeWhere((pelanggan) => pelanggan.id == id);
      });
    } catch (e) {
      // ganti
      _showErrorSnackbar('Gagal menghapus pelanggan');
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            // ganti
            content: const Text('Yakin ingin menghapus pelanggan ini?'),
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

  // ========== WIDGET TERPISAH UNTUK LIST PELANGGAN ==========

  // 1. Widget untuk AppBar dengan tombol tambah || INI GANTI
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      // ganti
      title: const Text('List Pelanggan'),
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
          // SIDE BAR INI BANGGG
          _buildDrawerItem(
            title: 'Produk',
            icon: Icons.shop,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProdukPage()),
              );
            },
          ),
          _buildDrawerItem(
            title: 'Pelanggan', 
            icon: Icons.person, 
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PelangganPage()),
              );
            }),
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
            'Belum ada pelanggan',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            // ganti
            'Tap tombol + untuk menambah pelanggan',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // 7. Widget untuk product list || INI GANTI
  Widget _buildProductList() {
    // ganti
    if (_pelangganList.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      // ganti
      itemCount: _pelangganList.length,
      // ganti
      itemBuilder: (context, index) => _buildProductItem(_pelangganList[index]),
    );
  }

  // 8. Widget untuk setiap item pelanggan || INI GANTI (parameter)
  Widget _buildProductItem(Pelanggan pelanggan) {
    return GestureDetector(
      // ganti
      onTap: () => _navigateToProductDetail(pelanggan),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        // ganti
        child: _buildProductTile(pelanggan),
      ),
    );
  }

  // 9. Widget untuk ListTile pelanggan || INI GANTI (parameter)
  ListTile _buildProductTile(Pelanggan pelanggan) {
    return ListTile(
      leading: _buildProductIcon(),
      title: Text(
        // ganti
        pelanggan.nama ?? 'Nama tidak tersedia',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        // ganti
        'Rp. ${_formatHarga(pelanggan.totalBelanja as double?)}',
        style: TextStyle(color: Colors.green[700]),
      ),
      // ganti
      trailing: _buildDeleteButton(pelanggan),
    );
  }

  // 10. Widget untuk icon pelanggan
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
  Widget _buildDeleteButton(Pelanggan pelanggan) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      // ganti
      onPressed: () => _showDeleteConfirmation(pelanggan),
    );
  }

  // ========== HELPER METHODS ==========

  // Method untuk format harga
  String _formatHarga(double? harga) {
    if (harga == null) return '0';
    // Bisa ditambah format currency yang lebih bagus
    return harga.toStringAsFixed(0);
  }

  // Method untuk navigasi ke form tambah pelanggan || INI GANTI
  void _navigateToAddProduct(BuildContext context) async {
    await Navigator.push(
      context,
      // ganti
      MaterialPageRoute(builder: (context) => PelangganForm()),
    );
    _fetchPelanggan();
  }

  // Method untuk navigasi ke detail pelanggan || INI GANTI (parameter)
  void _navigateToProductDetail(Pelanggan pelanggan) {
    Navigator.push(
      context,
      // ganti
      MaterialPageRoute(builder: (context) => PelangganDetail(pelanggan: pelanggan)),
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
  void _showDeleteConfirmation(Pelanggan pelanggan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          // ganti
          content: Text('Hapus pelanggan "${pelanggan.nama ?? 'ini'}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // ganti
                _deletePelanggan(pelanggan.id!);
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
