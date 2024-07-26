import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _userId = "";
  String _phone = "";
  String _name = "";
  String _password = "";
  String _email = "";
  String get userId => _userId;
  String get name => _name;
  String get phone => _phone;
  String get password => _password;
  String get email => _email;
  void setUserId(
      String userId, String name, String email, String phone, String password) {
    _userId = userId;
    _name = name;
    _phone = phone;
    _email = email;
    _password = password;
    notifyListeners();
  }

}
