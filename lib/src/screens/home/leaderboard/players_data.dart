import 'dart:convert';

class PlayersDataForRanking {
  final int playerCode;
  final int countryId;
  final String playerName;
  final String role;
  final String playerImage;
  final int status;
  final int point;

  PlayersDataForRanking({
    required this.playerCode,
    required this.countryId,
    required this.playerName,
    required this.role,
    required this.playerImage,
    required this.status,
    required this.point,
  });

  PlayersDataForRanking copyWith({
    int? playerCode,
    int? countryId,
    String? playerName,
    String? role,
    String? playerImage,
    int? status,
    int? point,
  }) =>
      PlayersDataForRanking(
        playerCode: playerCode ?? this.playerCode,
        countryId: countryId ?? this.countryId,
        playerName: playerName ?? this.playerName,
        role: role ?? this.role,
        playerImage: playerImage ?? this.playerImage,
        status: status ?? this.status,
        point: point ?? this.point,
      );

  factory PlayersDataForRanking.fromJson(String str) =>
      PlayersDataForRanking.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PlayersDataForRanking.fromMap(Map<String, dynamic> json) =>
      PlayersDataForRanking(
        playerCode: json["player_code"],
        countryId: json["country_id"],
        playerName: json["player_name"],
        role: json["role"],
        playerImage: json["player_image"],
        status: json["status"],
        point: json["point"],
      );

  Map<String, dynamic> toMap() => {
        "player_code": playerCode,
        "country_id": countryId,
        "player_name": playerName,
        "role": role,
        "player_image": playerImage,
        "status": status,
        "point": point,
      };
}
