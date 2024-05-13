import 'dart:convert';

class PlayerInfoModel {
  final int playerCode;
  final String playerName;
  final String role;
  final String playerImage;
  final String countryName;
  final String countryImage;
  final int? runPoint;
  final int? wicketPoint;
  final int? totalPoint;

  PlayerInfoModel({
    required this.playerCode,
    required this.playerName,
    required this.role,
    required this.playerImage,
    required this.countryName,
    required this.countryImage,
    this.runPoint,
    this.wicketPoint,
    this.totalPoint,
  });

  PlayerInfoModel copyWith({
    int? playerCode,
    String? playerName,
    String? role,
    String? playerImage,
    String? countryName,
    String? countryImage,
    int? runPoint,
    int? wicketPoint,
    int? totalPoint,
  }) =>
      PlayerInfoModel(
        playerCode: playerCode ?? this.playerCode,
        playerName: playerName ?? this.playerName,
        role: role ?? this.role,
        playerImage: playerImage ?? this.playerImage,
        countryName: countryName ?? this.countryName,
        countryImage: countryImage ?? this.countryImage,
        runPoint: runPoint ?? this.runPoint,
        wicketPoint: wicketPoint ?? this.wicketPoint,
        totalPoint: totalPoint ?? this.totalPoint,
      );

  factory PlayerInfoModel.fromJson(String str) =>
      PlayerInfoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlayerInfoModel.fromMap(Map<String, dynamic> json) => PlayerInfoModel(
        playerCode: json["player_code"],
        playerName: json["player_name"],
        role: json["role"],
        playerImage: json["player_image"],
        countryName: json["country_name"],
        countryImage: json["country_image"],
        runPoint: json["run_point"],
        wicketPoint: json["wicket_point"],
        totalPoint: json["total_point"],
      );

  Map<String, dynamic> toMap() => {
        "player_code": playerCode,
        "player_name": playerName,
        "role": role,
        "player_image": playerImage,
        "country_name": countryName,
        "country_image": countryImage,
        "run_point": runPoint,
        "wicket_point": wicketPoint,
        "total_point": totalPoint,
      };
}
