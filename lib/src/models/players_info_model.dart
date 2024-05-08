import 'dart:convert';

class PlayerInfoModel {
  final int playerCode;
  final int countryId;
  final String playerName;
  final String role;
  final String playerImage;

  PlayerInfoModel({
    required this.playerCode,
    required this.countryId,
    required this.playerName,
    required this.role,
    required this.playerImage,
  });

  PlayerInfoModel copyWith({
    int? playerCode,
    int? countryId,
    String? playerName,
    String? role,
    String? playerImage,
  }) =>
      PlayerInfoModel(
        playerCode: playerCode ?? this.playerCode,
        countryId: countryId ?? this.countryId,
        playerName: playerName ?? this.playerName,
        role: role ?? this.role,
        playerImage: playerImage ?? this.playerImage,
      );

  factory PlayerInfoModel.fromJson(String str) =>
      PlayerInfoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlayerInfoModel.fromMap(Map<String, dynamic> json) => PlayerInfoModel(
        playerCode: json["player_code"],
        countryId: json["country_id"],
        playerName: json["player_name"],
        role: json["role"],
        playerImage: json["player_image"],
      );

  Map<String, dynamic> toMap() => {
        "player_code": playerCode,
        "country_id": countryId,
        "player_name": playerName,
        "role": role,
        "player_image": playerImage,
      };
}
