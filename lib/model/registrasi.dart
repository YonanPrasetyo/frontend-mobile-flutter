class Registrasi {
  int? code;
  bool? success;
  Map<String, dynamic>? data;

  Registrasi({this.code, this.success, this.data});

  factory Registrasi.fromJson(Map<String, dynamic> obj) {
    print('Registrasi: $obj');
    return Registrasi(
      code: obj['code'],
      success: obj['success'],
      data: obj['data'],
    );
  }
}
