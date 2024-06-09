import 'package:flutter/material.dart';

class GetBookMarkModel {
  final int statusCode;
  final String message;
  final List<Bookmark> bookmarks;

  GetBookMarkModel({
    required this.statusCode,
    required this.message,
    required this.bookmarks,
  });

  factory GetBookMarkModel.fromJson(Map<String, dynamic> json) {
    return GetBookMarkModel(
      statusCode: json['statusCode'],
      message: json['message'],
      bookmarks: (json['bookmarks'] as List)
          .map((bookmark) => Bookmark.fromJson(bookmark))
          .toList(),
    );
  }
}

class Bookmark {
  final int bookmarkId;
  final double latitude;
  final double longitude;

  Bookmark({
    required this.bookmarkId,
    required this.latitude,
    required this.longitude,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      bookmarkId: json['bookmarkId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
