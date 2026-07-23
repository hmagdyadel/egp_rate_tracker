import 'package:json_annotation/json_annotation.dart';

part 'rates_response_model.g.dart';

/// Data model matching the currency-api response shape.
///
/// API response: `{ "date": "2026-07-23", "egp": { "usd": 0.019227, ... } }`
///
/// We only pluck the 5 tracked currencies from the `egp` map — the other
/// ~200 keys are ignored. The raw values are EGP-to-foreign (e.g. how many
/// USD per 1 EGP); inversion to foreign-to-EGP happens in the mapper, not here.
@JsonSerializable()
class RatesResponseModel {
  const RatesResponseModel({
    required this.date,
    required this.egp,
  });

  /// The date this snapshot applies to (e.g. "2026-07-23").
  final String date;

  /// Raw currency map: `{ "usd": 0.019227, "eur": 0.017583, ... }`
  ///
  /// Contains ~200 keys; the mapper extracts only the 5 we care about.
  final Map<String, dynamic> egp;

  factory RatesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RatesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RatesResponseModelToJson(this);
}
