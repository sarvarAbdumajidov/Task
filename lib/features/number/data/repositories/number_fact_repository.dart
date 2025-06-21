import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:interesting_number/features/number/data/models/number_model.dart';
import 'package:interesting_number/services/log_service.dart';
import 'package:interesting_number/core/utils/enums.dart';

class NumberFactRepository {
  static const String _baseUrl = 'http://numbersapi.com';

  Future<Number> fetchNumberFact({
    int? number,
    required Type type,
    bool isRandom = false,
    int? month,
    int? day,
  }) async {
    try {
      String typeStr = type.name;
      late String url;

      if (type == Type.date && month != null && day != null) {
        url = '$_baseUrl/$month/$day/date?json';
      } else if (isRandom) {
        url = '$_baseUrl/random/$typeStr?json';
      } else if (number != null) {
        url = '$_baseUrl/$number/$typeStr?json';
      } else {
        throw Exception('Number or Date dont input');
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Number.fromJson(data);
      } else {
        LogService.e('Server error: ${response.statusCode}');
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      LogService.e('fetchNumberFact error: $e');
      rethrow;
    }
  }
}
