class AddScheduleModel {
  final int statusCode;
  final String message;

  AddScheduleModel({
    required this.statusCode,
    required this.message,
  });

    factory AddScheduleModel.fromJson(Map<String, dynamic> json) {
    return AddScheduleModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
