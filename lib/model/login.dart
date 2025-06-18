class Login {
  bool? success;
  String? token;
  int? userID;
  String? userEmail;

  Login({this.success, this.token, this.userID, this.userEmail});

  factory Login.fromJson(Map<String, dynamic> obj) {
    return Login(
      success: obj['success'],
      token: obj['token'],
      userID: obj['user']?['id'],
      userEmail: obj['user']?['email'],
    );
  }
}
