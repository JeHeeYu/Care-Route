class MypageModel {
  final int statusCode;
  final String message;
  final int memberId;
  final String? nickname;
  final String? role;
  final String? address;
  final String? profileImage;

  MypageModel({
    required this.statusCode,
    required this.message,
    required this.memberId,
    this.nickname,
    this.role,
    this.address,
    this.profileImage,
  });

  factory MypageModel.fromJson(Map<String, dynamic> json) {
    return MypageModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      memberId: json['memberId'] ?? 0,
      nickname: json['nickname'],
      role: json['role'],
      address: json['address'],
      profileImage: json['profileImage'],
    );
  }
}
