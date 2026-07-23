// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rates_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatesResponseModel _$RatesResponseModelFromJson(Map<String, dynamic> json) =>
    RatesResponseModel(
      date: json['date'] as String,
      egp: json['egp'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$RatesResponseModelToJson(RatesResponseModel instance) =>
    <String, dynamic>{'date': instance.date, 'egp': instance.egp};
