import 'package:flutter/material.dart';

class ModalProvider extends ChangeNotifier {
  bool _isActive = false;
  bool get isActive => _isActive;

  void setModalStatus(bool isActive) {
    _isActive = isActive;
    notifyListeners();
  }
}
