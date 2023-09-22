import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserData with ChangeNotifier {
  String? baseUrl = dotenv.get('BASE_URL', fallback: 'BASE_URL not found');

  Map<String, dynamic>? _user;

  Map<String, dynamic>? get user => _user;

  Future<void> setUser(userId, token) async {
    print('token in setUser $userId');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/myuser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          <String, String>{
            '_id': userId,
          },
        ),
      );

      if (response.statusCode == 200) {
        final user = jsonDecode(response.body);
        user['user_id'] = userId;
        _user = user;
        print('user $_user');
        notifyListeners();
      } else {
        print(
            'Failed to fetch data in SetUser. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch data in SetUser. Status code: $e');
    }
  }
}
