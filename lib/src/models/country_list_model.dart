import 'dart:convert';

class CountryListModel {
  final List<Result> results;

  CountryListModel({
    required this.results,
  });

  CountryListModel copyWith({
    List<Result>? results,
  }) =>
      CountryListModel(
        results: results ?? this.results,
      );

  factory CountryListModel.fromJson(String str) =>
      CountryListModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CountryListModel.fromMap(Map<String, dynamic> json) =>
      CountryListModel(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
      };
}

class Result {
  final int countryId;
  final String countryName;
  final String countryImage;

  Result({
    required this.countryId,
    required this.countryName,
    required this.countryImage,
  });

  Result copyWith({
    int? countryId,
    String? countryName,
    String? countryImage,
  }) =>
      Result(
        countryId: countryId ?? this.countryId,
        countryName: countryName ?? this.countryName,
        countryImage: countryImage ?? this.countryImage,
      );

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        countryId: json["country_id"],
        countryName: json["country_name"],
        countryImage: json["country_image"],
      );

  Map<String, dynamic> toMap() => {
        "country_id": countryId,
        "country_name": countryName,
        "country_image": countryImage,
      };
}
