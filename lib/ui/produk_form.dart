import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;

  const ProdukForm({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late String _judul;
  late String _tombolSubmit;

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.produk != null) {
      _judul = "UBAH PRODUK";
      _tombolSubmit = "UBAH";
      _kodeProdukTextboxController.text = widget.produk!.kodeProduk ?? "";
      _namaProdukTextboxController.text = widget.produk!.namaProduk ?? "";
      _hargaProdukTextboxController.text = widget.produk!.hargaProduk
          .toString();
    } else {
      _judul = "TAMBAH PRODUK";
      _tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _kodeProdukTextField(),
                _namaProdukTextField(),
                _hargaProdukTextField(),
                const SizedBox(height: 20),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _kodeProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Kode Produk"),
      keyboardType: TextInputType.text,
      controller: _kodeProdukTextboxController,
      validator: (value) =>
          (value == null || value.isEmpty) ? "Kode Produk harus diisi" : null,
    );
  }

  Widget _namaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Produk"),
      keyboardType: TextInputType.text,
      controller: _namaProdukTextboxController,
      validator: (value) =>
          (value == null || value.isEmpty) ? "Nama Produk harus diisi" : null,
    );
  }

  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Harga Produk"),
      keyboardType: TextInputType.number,
      controller: _hargaProdukTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) return "Harga Produk harus diisi";
        if (double.tryParse(value) == null)
          return "Harga Produk harus berupa angka";
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return ElevatedButton(
      child: _isLoading
          ? const CircularProgressIndicator()
          : Text(_tombolSubmit),
      onPressed: _isLoading ? null : _submit,
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      Produk produk = Produk(
        id: widget.produk?.id,
        kodeProduk: _kodeProdukTextboxController.text,
        namaProduk: _namaProdukTextboxController.text,
        hargaProduk:
            double.tryParse(_hargaProdukTextboxController.text)?.toInt() ?? 0,
      );

      bool success;
      if (widget.produk == null) {
        success = await ProdukBloc.addProduk(produk: produk);
      } else {
        success = await ProdukBloc.updateProduk(produk: produk);
      }

      if (success) {
        _navigateToProdukPage();
      } else {
        _showErrorDialog("Gagal menyimpan produk.");
      }
    } catch (e) {
      _showErrorDialog("Terjadi kesalahan: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToProdukPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ProdukPage()),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => WarningDialog(description: message),
    );
  }
}
