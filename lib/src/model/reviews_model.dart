// To parse this JSON data, do
//
//     final reviwes = reviwesFromJson(jsonString);

import 'dart:convert';

Reviwes reviwesFromJson(String str) => Reviwes.fromJson(json.decode(str));

String reviwesToJson(Reviwes data) => json.encode(data.toJson());

class Reviwes {
  String? message;
  List<Review>? reviews;

  Reviwes({
    this.message,
    this.reviews,
  });

  factory Reviwes.fromJson(Map<String, dynamic> json) => Reviwes(
    message: json["message"],
    reviews: json["reviews"] == null ? [] : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x.toJson())),
  };
}

class Review {
  String? id;
  String? bookId;
  String? userId;
  String? name;
  double? rating;
  String? comment;
  DateTime? date;
  DateTime? createdAt;
  DateTime? updatedAt;

  Review({
    this.id,
    this.bookId,
    this.userId,
    this.name,
    this.rating,
    this.comment,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["id"],
    bookId: json["bookId"],
    userId: json["userId"],
    name: json["name"],
    rating: json["rating"]?.toDouble(),
    comment: json["comment"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bookId": bookId,
    "userId": userId,
    "name": name,
    "rating": rating,
    "comment": comment,
    "date": date?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
