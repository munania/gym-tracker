import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quotes.dart';

class UserApi {
  static Future<List<Quotes>> motivation() async {
    const url = "https://type.fit/api/quotes";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json as List<dynamic>;

    final allQuotes = results.map((e) {
      return Quotes.fromMap(e);
    }).toList();

    return allQuotes;
  }
}
