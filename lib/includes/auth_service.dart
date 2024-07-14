// ignore_for_file: use_build_context_synchronously

import 'package:FinTask/includes/url.dart';
import 'package:FinTask/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final String baseUrl = '${Url.url}/login';
  final Uri url = Uri.parse(baseUrl);
  var logger = Logger();
  Future<void> storeToken(String token, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userId', userId.toString());
  }

  Future<Map<String, String?>> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');

    return {'userId': userId, 'token': token};
  }

  Future<bool> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove("token");
  }

  Future<Map<String, dynamic>> login(
      BuildContext context, email, String password) async {
    final Map<String, dynamic> data = {'email': email, 'password': password};
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      final resData = jsonDecode(response.body);
      // print(resData['result'][0]);
      final String userId = resData['result'][0]['id'].toString();
      final String name = resData['result'][0]['name'];
      final String email = resData['result'][0]['email'];
      final String password = resData['result'][0]['password'];
      await storeToken(responseData['token'], userId.toString());

      final user = context.read<UserProvider>();
      user.setUserId(userId, name, email, password);
      // Navigator.pushReplacementNamed(context, "/homecontroller");
      Navigator.pushNamed(context, "/homecontroller");
    } else {
      logger.e(response.body);
    }

    return responseData;
  }
}
