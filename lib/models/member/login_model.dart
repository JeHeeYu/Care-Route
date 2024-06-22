class LoginModel {
  final int statusCode;
  final String message;
  final int? memberId;
  final String nickname;
  final String type;
  final String? phoneNumber;
  final String? imageUrl;

  LoginModel({
    required this.statusCode,
    required this.message,
    this.memberId,
    required this.nickname,
    required this.type,
    this.phoneNumber,
    this.imageUrl,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      memberId: json['memberId'],
      nickname: json['nickname'] ?? '',
      type: json['type'] ?? '',
      phoneNumber: json['phoneNumber'],
      imageUrl: json['imageUrl'],
    );
  }
}
