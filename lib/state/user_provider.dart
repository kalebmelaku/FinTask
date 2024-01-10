import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  // String _crsid = "";
  // bool _isActive = false;
  // String _profilePic = "";
  // String get crsid => _crsid;
  // String get profilePic => _profilePic;
  // bool get isActive => _isActive;
  String _userId = "";
  String _name = "";
  String _password = "";
  String _email = "";
  String get userId => _userId;
  String get name => _name;
  String get password => _password;
  String get email => _email;

  void setUserId(
      String userId, String name, String email, String password) {
    _userId = userId;
    _name = name;
    _email = email;
    _password = password;
    notifyListeners();
    // _profilePic = profilePic;
  }

}
