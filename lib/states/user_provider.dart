import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _userId = "";
  String _crsid = "";
  String _name = "";
  int _year = 0;
  String _email = "";
  String _profilePic = "";
  String get userId => _userId;
  String get crsid => _crsid;
  String get name => _name;
  int get year => _year;
  String get email => _email;
  String get profilePic => _profilePic;

  void setUserId(String userId, String name, int year, String email, String profilePic) {
    _userId = userId;
    _name = name;
    _year = year;
    _email = email;
    _profilePic = profilePic;
    notifyListeners();
  }

  void setCourseId(String crsid) {
    _crsid = crsid;
    notifyListeners();
  }
}