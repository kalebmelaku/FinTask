import 'dart:convert';

import 'package:FinTask/includes/url.dart';
import 'package:FinTask/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

final String baseUrl = Url.url;

Future<void> getUserInfo(BuildContext context, userId) async {
  // final Map<String, dynamic> data = {'password': password};
  final Uri url = Uri.parse('$baseUrl/userInfo/$userId');
  final response = await http.get(url);
  // final responseData = json.decode(response.body);
  if (response.statusCode == 201) {
    final resData = jsonDecode(response.body);
    final String userId = resData['result'][0]['id'].toString();
    final String name = resData['result'][0]['name'];
    final String email = resData['result'][0]['email'];
    final String phone = resData['result'][0]['phone'];
    final String password = resData['result'][0]['password'];

    // ignore: use_build_context_synchronously
    final user = context.read<UserProvider>();
    user.setUserId(userId, name, email, phone, password);
  } else {
    print(response.body);
  }
}
