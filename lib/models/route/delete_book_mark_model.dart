import 'package:flutter/material.dart';

class DeleteBookMarkModel {
  final int statusCode;
  final String message;

  DeleteBookMarkModel({
    required this.statusCode,
    required this.message,
  });

  factory DeleteBookMarkModel.fromJson(Map<String, dynamic> json) {
    return DeleteBookMarkModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'],
    );
  }
}
