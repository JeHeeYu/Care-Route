class NicknameUpdateModel {
  final int statusCode;
  final String message;

  NicknameUpdateModel({
    required this.statusCode,
    required this.message,
  });

    factory NicknameUpdateModel.fromJson(Map<String, dynamic> json) {
    return NicknameUpdateModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
