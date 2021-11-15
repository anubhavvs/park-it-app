import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  bool _activeBooking;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  bool get active {
    print(_activeBooking);
    return _activeBooking;
  }

  Future<void> signup(String email, String password, String name, String number,
      String plate) async {
    var url = FlutterConfig.get('API_URL') + '/users/register';
    var uri = Uri.parse(url);
    try {
      final response = await http.post(uri,
          body: json.encode({
            'name': name,
            'email': email,
            'password': password,
            'plate': plate,
            'number': number
          }),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 400) {
        throw HttpException(json.decode(response.body)['message']);
      }
      _token = json.decode(response.body)['token'];
      _userId = json.decode(response.body)['_id'];
      _expiryDate = DateTime.now().add(Duration(days: 30));
      _activeBooking = json.decode(response.body)['activeBooking'];
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('user', userData);
      prefs.setBool('activeBooking', _activeBooking);
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    var url = FlutterConfig.get('API_URL') + '/users/login';
    var uri = Uri.parse(url);
    try {
      final response = await http.post(uri,
          body: json.encode({'email': email, 'password': password}),
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 401) {
        throw HttpException(json.decode(response.body)['message']);
      }
      if (json.decode(response.body)['isAdmin']) {
        throw HttpException('Admin users not allowed.');
      }
      _token = json.decode(response.body)['token'];
      _userId = json.decode(response.body)['_id'];
      _expiryDate = DateTime.now().add(Duration(days: 30));
      _activeBooking = json.decode(response.body)['activeBooking'];
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      prefs.setString('user', userData);
      prefs.setBool('activeBooking', _activeBooking);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('user') || !prefs.containsKey('activeBooking')) {
      return false;
    }
    final userData =
        json.decode(prefs.getString('user')) as Map<String, Object>;
    final expiryDate = DateTime.parse(userData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = userData['token'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;
    _activeBooking = prefs.getBool('activeBooking');
    print(_activeBooking);
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inDays;
    _authTimer = Timer(Duration(days: timeToExpiry), logout);
  }
}
