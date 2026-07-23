import 'package:flutter_test/flutter_test.dart';
import 'package:egp_rate_tracker/features/rates/data/models/rates_mapper.dart';
import 'package:egp_rate_tracker/features/rates/data/models/rates_response_model.dart';

void main() {
  late RatesMapper mapper;

  setUp(() {
    mapper = const RatesMapper();
  });

  group('RatesMapper', () {
    test('inverts raw EGP-to-foreign rate into foreign-to-EGP rate', () {
      // 0.02 USD per 1 EGP -> 1 / 0.02 = 50.0 EGP per 1 USD
      const today = RatesResponseModel(
        date: '2026-07-23',
        egp: {'usd': 0.02},
      );
      const yesterday = RatesResponseModel(
        date: '2026-07-22',
        egp: {'usd': 0.02},
      );

      final result = mapper.mapToCurrencyRates(today: today, yesterday: yesterday);

      final usdRate = result.firstWhere((r) => r.code == 'USD');
      expect(usdRate.rate, equals(50.0));
    });

    test('computes daily change absolute and percentage correctly', () {
      // Today: 0.02 (inverted = 50.0 EGP/USD)
      // Yesterday: 0.025 (inverted = 40.0 EGP/USD)
      // Absolute change = 50.0 - 40.0 = 10.0
      // Percent change = (10.0 / 40.0) * 100 = 25.0%
      const today = RatesResponseModel(
        date: '2026-07-23',
        egp: {'usd': 0.02},
      );
      const yesterday = RatesResponseModel(
        date: '2026-07-22',
        egp: {'usd': 0.025},
      );

      final result = mapper.mapToCurrencyRates(today: today, yesterday: yesterday);

      final usdRate = result.firstWhere((r) => r.code == 'USD');
      expect(usdRate.changeAbsolute, equals(10.0));
      expect(usdRate.changePercent, equals(25.0));
      expect(usdRate.isPositiveChange, isTrue);
    });

    test('handles yesterdayRate == 0 edge case without division by zero crash', () {
      const today = RatesResponseModel(
        date: '2026-07-23',
        egp: {'usd': 0.02},
      );
      const yesterday = RatesResponseModel(
        date: '2026-07-22',
        egp: {'usd': 0.0}, // 0 rate
      );

      final result = mapper.mapToCurrencyRates(today: today, yesterday: yesterday);

      final usdRate = result.firstWhere((r) => r.code == 'USD');
      expect(usdRate.changePercent, equals(0.0));
    });

    test('extracts only the 5 tracked currencies (USD, EUR, GBP, SAR, JPY) from 200+ keys', () {
      const today = RatesResponseModel(
        date: '2026-07-23',
        egp: {
          'usd': 0.02,
          'eur': 0.018,
          'gbp': 0.015,
          'sar': 0.075,
          'jpy': 3.0,
          '1inch': 0.25,
          'btc': 0.00002,
          'eth': 0.0003,
          'doge': 5.0,
        },
      );
      const yesterday = RatesResponseModel(
        date: '2026-07-22',
        egp: {
          'usd': 0.02,
          'eur': 0.018,
          'gbp': 0.015,
          'sar': 0.075,
          'jpy': 3.0,
        },
      );

      final result = mapper.mapToCurrencyRates(today: today, yesterday: yesterday);

      expect(result.length, equals(5));
      final codes = result.map((r) => r.code).toList();
      expect(codes, containsAll(['USD', 'EUR', 'GBP', 'SAR', 'JPY']));
      expect(codes, isNot(contains('1INCH')));
      expect(codes, isNot(contains('BTC')));
    });

    test('mapToHistoricalPoint extracts date and inverts rate for single currency', () {
      const response = RatesResponseModel(
        date: '2026-07-20',
        egp: {'usd': 0.02},
      );

      final point = mapper.mapToHistoricalPoint(
        response: response,
        currencyCode: 'usd',
      );

      expect(point.date, equals(DateTime.parse('2026-07-20')));
      expect(point.rate, equals(50.0));
    });
  });
}
