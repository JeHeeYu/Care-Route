import 'package:flutter/material.dart';

class SetBookMarkModel {
  final int statusCode;
  final String message;
  final int bookmarkId;

  SetBookMarkModel({
    required this.statusCode,
    required this.message,
    required this.bookmarkId,
  });

  factory SetBookMarkModel.fromJson(Map<String, dynamic> json) {
    return SetBookMarkModel(
      statusCode: json['statusCode'],
      message: json['message'],
      bookmarkId: json['bookmarkId'],
    );
  }
}
