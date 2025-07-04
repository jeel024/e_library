// To parse this JSON data, do
//
//     final getGenderData = getGenderDataFromJson(jsonString);

import 'dart:convert';

GetGenderData getGenderDataFromJson(String str) => GetGenderData.fromJson(json.decode(str));

String getGenderDataToJson(GetGenderData data) => json.encode(data.toJson());

class GetGenderData {
  List? category;
  String? id;
  String? userId;
  dynamic language;
  String? gender;
  DateTime? createdAt;
  DateTime? updatedAt;

  GetGenderData({
    this.category,
    this.id,
    this.userId,
    this.language,
    this.gender,
    this.createdAt,
    this.updatedAt,
  });

  factory GetGenderData.fromJson(Map<String, dynamic> json) => GetGenderData(
    category: json["category"] == null ? [] : List.from(json["category"]!.map((x) => x)),
    id: json["id"],
    userId: json["userId"],
    language: json["language"],
    gender: json["gender"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "category": category == null ? [] : List.from(category!.map((x) => x)),
    "id": id,
    "userId": userId,
    "language": language,
    "gender": gender,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
