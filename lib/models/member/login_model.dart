class LoginModel {
  final int statusCode;
  final String message;
  final int? memberId;
  final String? type;

  LoginModel({
    required this.statusCode,
    required this.message,
    this.memberId,
    this.type,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      memberId: json['memberId'],
      type: json['type'],
    );
  }
}
