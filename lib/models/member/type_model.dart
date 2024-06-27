class TypeModel {
  final int statusCode;
  final String message;

  TypeModel({
    required this.statusCode,
    required this.message,
  });

  factory TypeModel.fromJson(Map<String, dynamic> json) {
    return TypeModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
