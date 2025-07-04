// To parse this JSON data, do
//
//     final bookModel = bookModelFromJson(jsonString);

import 'dart:convert';

List<BookModel> bookModelFromJson(String str) => List<BookModel>.from(json.decode(str).map((x) => BookModel.fromJson(x)));

String bookModelToJson(List<BookModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookModel {
  final String? category;
  final String? review;
  final String? id;
  final String? name;
  final String? author;
  final String? publisher;
  final String? price;
  final String? language;
  final String? book;
  final String? description;
  final String? downloads;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BookModel({
    this.category,
    this.review,
    this.id,
    this.name,
    this.author,
    this.publisher,
    this.price,
    this.language,
    this.book,
    this.description,
    this.downloads,
    this.createdAt,
    this.updatedAt,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
    category: json["category"],
    review: json["review"],
    id: json["id"],
    name: json["name"],
    author: json["author"],
    publisher: json["publisher"],
    price: json["price"],
    language: json["language"],
    book: json["book"],
    description: json["description"],
    downloads: json["downloads"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "review": review,
    "id": id,
    "name": name,
    "author": author,
    "publisher": publisher,
    "price": price,
    "language": language,
    "book": book,
    "description": description,
    "downloads": downloads,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
