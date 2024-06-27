class TargetListModel {
  final int statusCode;
  final String message;
  final List<TargetInfo> targetInfos;

  TargetListModel({
    required this.statusCode,
    required this.message,
    required this.targetInfos,
  });

  factory TargetListModel.fromJson(Map<String, dynamic> json) {
    return TargetListModel(
      statusCode: json['statusCode'],
      message: json['message'],
      targetInfos: List<TargetInfo>.from(json['targetInfos'].map((x) => TargetInfo.fromJson(x))),
    );
  }
}

class TargetInfo {
  final int memberId;
  final String nickname;
  final String? profileImage;

  TargetInfo({
    required this.memberId,
    required this.nickname,
    this.profileImage,
  });

  factory TargetInfo.fromJson(Map<String, dynamic> json) {
    return TargetInfo(
      memberId: json['memberId'],
      nickname: json['nickname'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'nickname': nickname,
      'profileImage': profileImage,
    };
  }
}
