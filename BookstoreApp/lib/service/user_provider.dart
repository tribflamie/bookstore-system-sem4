import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int _id = 0;
  String _username = '';
  String _email = '';
  bool _isLoggedIn = false;

  int get id=> _id;
  String get username => _username;
  String get email => _email;
  bool get isLoggedIn => _isLoggedIn;

  void setUserInfo(int id, String name, String email) {
    _id = id;
    _username = name;
    _email = email;
    _isLoggedIn = true;
    notifyListeners();
  }
  void logout() {
    _id = 0;
    _username = '';
    _email = '';
    _isLoggedIn = false;
    notifyListeners();
  }
}