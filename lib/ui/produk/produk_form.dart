import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk/produk_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

// ganti nama class
class ProdukForm extends StatefulWidget {
  // ganti
  final Produk? produk;

  // ganti
  const ProdukForm({Key? key, this.produk}) : super(key: key);

  @override
  // ganti
  _ProdukFormState createState() => _ProdukFormState();
}

// ganti nama class
class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late String _judul;
  late String _tombolSubmit;

  // yang perlu di sesuaikan 
  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ganti
    if (widget.produk != null) {
      // ganti
      _judul = "UBAH PRODUK";
      _tombolSubmit = "UBAH";
      // yang perlu di sesuaikan
      _kodeProdukTextboxController.text = widget.produk!.kodeProduk ?? "";
      _namaProdukTextboxController.text = widget.produk!.namaProduk ?? "";
      // ini kalau bentuk angka
      _hargaProdukTextboxController.text = widget.produk!.hargaProduk
          .toString();
    } else {
      // ganti
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
                // tulis kode di bawah ini
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

  // yang ini template yah
  Widget _buildTextFormField({
    required String labelText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? customValidator,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: labelText),
      keyboardType: keyboardType,
      controller: controller,
      validator:
          customValidator ??
          (value) => (value == null || value.isEmpty)
              ? "$labelText harus diisi"
              : null,
    );
  }

  // ini cukup panggil fungsi yang di atas
  Widget _kodeProdukTextField() {
    return _buildTextFormField(
      labelText: "Kode Produk",
      controller: _kodeProdukTextboxController,
    );
  }

  // ini cukup panggil fungsi yang di atas
  Widget _namaProdukTextField() {
    return _buildTextFormField(
      labelText: "Nama Produk",
      controller: _namaProdukTextboxController,
    );
  }

  // ini cukup panggil fungsi yang di atas (ini contoh yung ada validatornya)
  Widget _hargaProdukTextField() {
    return _buildTextFormField(
      labelText: "Harga Produk",
      controller: _hargaProdukTextboxController,
      keyboardType: TextInputType.number,
      customValidator: (value) {
        if (value == null || value.isEmpty) return "Harga Produk harus diisi";
        if (double.tryParse(value) == null)
          return "Harga Produk harus berupa angka";
        return null;
      },
    );
  }

  // ========== CONTOH VALIDATOR CUSTOM LAINNYA ==========

// 1. Validator untuk Email
// Widget _emailTextField() {
//   return _buildTextFormField(
//     labelText: "Email",
//     controller: _emailController,
//     keyboardType: TextInputType.emailAddress,
//     customValidator: (value) {
//       if (value == null || value.isEmpty) return "Email harus diisi";
//       String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4};
//       RegExp regex = RegExp(pattern);
//       if (!regex.hasMatch(value)) return "Format email tidak valid";
//       return null;
//     },
//   );
// }

// 2. Validator untuk Nomor HP
// Widget _nomorHpTextField() {
//   return _buildTextFormField(
//     labelText: "Nomor HP",
//     controller: _nomorHpController,
//     keyboardType: TextInputType.phone,
//     customValidator: (value) {
//       if (value == null || value.isEmpty) return "Nomor HP harus diisi";
//       if (value.length < 10) return "Nomor HP minimal 10 digit";
//       if (value.length > 15) return "Nomor HP maksimal 15 digit";
//       if (!RegExp(r'^[0-9+]+).hasMatch(value)) return "Nomor HP hanya boleh angka";
//       return null;
//     },
//   );
// }

// 3. Validator untuk Password
// Widget _passwordTextField() {
//   return _buildTextFormField(
//     labelText: "Password",
//     controller: _passwordController,
//     customValidator: (value) {
//       if (value == null || value.isEmpty) return "Password harus diisi";
//       if (value.length < 8) return "Password minimal 8 karakter";
//       if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
//         return "Password harus ada huruf besar, kecil, dan angka";
//       }
//       return null;
//     },
//   );
// }

// 4. Validator untuk Umur
// Widget _umurTextField() {
//   return _buildTextFormField(
//     labelText: "Umur",
//     controller: _umurController,
//     keyboardType: TextInputType.number,
//     customValidator: (value) {
//       if (value == null || value.isEmpty) return "Umur harus diisi";
//       int? umur = int.tryParse(value);
//       if (umur == null) return "Umur harus berupa angka";
//       if (umur < 1 || umur > 120) return "Umur harus antara 1-120 tahun";
//       return null;
//     },
//   );
// }

// 5. Validator untuk Username (alphanumeric, minimal 3 karakter)
// Widget _usernameTextField() {
//   return _buildTextFormField(
//     labelText: "Username",
//     controller: _usernameController,
//     customValidator: (value) {
//       if (value == null || value.isEmpty) return "Username harus diisi";
//       if (value.length < 3) return "Username minimal 3 karakter";
//       if (!RegExp(r'^[a-zA-Z0-9_]+).hasMatch(value)) {
//         return "Username hanya boleh huruf, angka, dan underscore";
//       }
//       return null;
//     },
//   );
// }

// 6. Validator untuk Persentase (0-100)
// Widget _persentaseTextField() {
//   return _buildTextFormField(
//     labelText: "Persentase (%)",
//     controller: _persentaseController,
//     keyboardType: TextInputType.number,
//     customValidator: (value) {
//       if (value == null || value.isEmpty) return "Persentase harus diisi";
//       double? percent = double.tryParse(value);
//       if (percent == null) return "Persentase harus berupa angka";
//       if (percent < 0 || percent > 100) return "Persentase harus antara 0-100";
//       return null;
//     },
//   );
// }

// 7. Validator untuk Nama (hanya huruf dan spasi)
// Widget _namaLengkapTextField() {
//   return _buildTextFormField(
//     labelText: "Nama Lengkap",
//     controller: _namaLengkapController,
//     customValidator: (value) {
//       if (value == null || value.isEmpty) return "Nama lengkap harus diisi";
//       if (!RegExp(r'^[a-zA-Z\s]+).hasMatch(value)) {
//         return "Nama hanya boleh huruf dan spasi";
//       }
//       if (value.trim().split(' ').length < 2) return "Masukkan nama lengkap (min 2 kata)";
//       return null;
//     },
//   );
// }

// 8. Validator untuk Nama (hanya huruf dan spasi)
// Widget _namaLengkapTextField() {
//   return _buildTextFormField(
//     labelText: "Nama Lengkap",
//     controller: _namaLengkapController,
//     customValidator: (value) {
//       if (value == null || value.isEmpty) return "Nama lengkap harus diisi";
//       if (!RegExp(r'^[a-zA-Z\s]+).hasMatch(value)) {
//         return "Nama hanya boleh huruf dan spasi";
//       }
//       if (value.trim().split(' ').length < 2) return "Masukkan nama lengkap (min 2 kata)";
//       return null;
//     },
//   );
// }
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
        // yang perlu diganti
        id: widget.produk?.id,
        kodeProduk: _kodeProdukTextboxController.text,
        namaProduk: _namaProdukTextboxController.text,
        // ini kalau bentuk angka
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
        // ini bang
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
