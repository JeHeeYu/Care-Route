class AuthModel {
  final int statusCode;
  final String message;

  AuthModel({
    required this.statusCode,
    required this.message,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
