class AccountModel {
  final int statusCode;
  final String message;

  AccountModel({
    required this.statusCode,
    required this.message,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
