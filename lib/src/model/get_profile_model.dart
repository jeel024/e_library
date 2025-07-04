// To parse this JSON data, do
//
//     final getProfile = getProfileFromJson(jsonString);

import 'dart:convert';

GetProfile getProfileFromJson(String str) => GetProfile.fromJson(json.decode(str));

String getProfileToJson(GetProfile data) => json.encode(data.toJson());

class GetProfile {
    String? id;
    String? userId;
    String? fullName;
    dynamic country;
    DateTime? birthDate;
    DateTime? createdAt;
    DateTime? updatedAt;

    GetProfile({
        this.id,
        this.userId,
        this.fullName,
        this.country,
        this.birthDate,
        this.createdAt,
        this.updatedAt,
    });

    factory GetProfile.fromJson(Map<String, dynamic> json) => GetProfile(
        id: json["id"],
        userId: json["userId"],
        fullName: json["fullName"],
        country: json["country"],
        birthDate: json["birthDate"] == null ? null : DateTime.parse(json["birthDate"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "fullName": fullName,
        "country": country,
        "birthDate": birthDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
