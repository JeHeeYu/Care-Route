import 'package:flutter/material.dart';

class DeleteBookMarkModel {
  final int statusCode;
  final String message;
  final int bookmarkId;

  DeleteBookMarkModel({
    required this.statusCode,
    required this.message,
    required this.bookmarkId,
  });

  factory DeleteBookMarkModel.fromJson(Map<String, dynamic> json) {
    return DeleteBookMarkModel(
      statusCode: json['statusCode'],
      message: json['message'],
      bookmarkId: json['bookmarkId'],
    );
  }
}
