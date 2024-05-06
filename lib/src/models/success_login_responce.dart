import 'dart:convert';

class Welcome {
  final bool success;
  final String message;
  final User user;

  Welcome({
    required this.success,
    required this.message,
    required this.user,
  });

  Welcome copyWith({
    bool? success,
    String? message,
    User? user,
  }) =>
      Welcome(
        success: success ?? this.success,
        message: message ?? this.message,
        user: user ?? this.user,
      );

  factory Welcome.fromJson(String str) => Welcome.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Welcome.fromMap(Map<String, dynamic> json) => Welcome(
        success: json["success"],
        message: json["message"],
        user: User.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "user": user.toMap(),
      };
}

class User {
  final int id;
  final String fullName;
  final String mobileNumber;
  final int? status;
  final String? createdAt;
  final String? updatedAt;

  User({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  User copyWith({
    int? id,
    String? fullName,
    String? mobileNumber,
    int? status,
    String? createdAt,
    String? updatedAt,
  }) =>
      User(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["full_name"],
        mobileNumber: json["mobile_number"],
        status: json["status"],
        createdAt: json["created_at"].runtimeType == Map
            ? DateTime.timestamp().toIso8601String()
            : null,
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "full_name": fullName,
        "mobile_number": mobileNumber,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
