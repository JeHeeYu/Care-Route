class DeleteTargetModel {
  final int statusCode;
  final String message;

  DeleteTargetModel({
    required this.statusCode,
    required this.message,
  });

    factory DeleteTargetModel.fromJson(Map<String, dynamic> json) {
    return DeleteTargetModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
