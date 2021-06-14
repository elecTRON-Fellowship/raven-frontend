import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  String? _authToken;
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _username;
  String? _email;
  String? _phoneNumber;
  String? _createdAt;

  Map<String, String?> get getUser {
    return {
      "authToken": _authToken,
      "id": _id,
      "firstName": _firstName,
      "lastName": _lastName,
      "userName": _username,
      "email": _email,
      "phoneNumber": _phoneNumber,
      "createdAt": _createdAt,
    };
  }

  Future<bool> register(String firstName, String lastName, String username,
      String email, String password, String phoneNumber) async {
    var url = Uri.parse('http://10.0.2.2:8000/register');

    // var url = Uri.parse('http://192.168.0.107:8000/register');
    // var url = Uri.https('localhost:8000', '/register');

    http
        .post(url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              "first_name": firstName,
              "last_name": lastName,
              "user_name": username,
              "email": email,
              "password": password,
              "phone_no": phoneNumber
            }))
        .then((res) {
      final data = json.decode(res.body);
      _authToken = data['accessToken'];
      _id = data['data']['id'].toString();
      _firstName = data['data']['first_name'];
      _lastName = data['data']['last_name'];
      _username = data['data']['user_name'];
      _email = data['data']['email'];
      _phoneNumber = data['data']['phone_no'];
      _createdAt = data['data']['created_at'];

      notifyListeners();

      SharedPreferences.getInstance().then((prefs) {
        final userData = json.encode({
          "auth_token": data['accessToken'],
          "id": data['data']['id'].toString(),
          "first_name": data['data']['first_name'],
          "last_name": data['data']['last_name'],
          "user_name": data['data']['user_name'],
          "email": data['data']['email'],
          "phone_no": data['data']['phone_no'],
          "created_at": data['data']['created_at']
        });
        prefs.setString('userData', userData);
        return true;
      });
    }).catchError((err) {
      throw err;
    });
    return false;
  }

  Future<bool> login(String phoneNumber, String password) async {
    var url = Uri.parse('http://10.0.2.2:8000/login');

    http
        .post(url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({"phone_no": phoneNumber, "password": password}))
        .then((res) {
      final data = json.decode(res.body);
      _authToken = data['accessToken'];
      _id = data['data']['id'].toString();
      _firstName = data['data']['first_name'];
      _lastName = data['data']['last_name'];
      _username = data['data']['user_name'];
      _email = data['data']['email'];
      _phoneNumber = data['data']['phone_no'];
      _createdAt = data['data']['created_at'];

      notifyListeners();

      SharedPreferences.getInstance().then((prefs) {
        final userData = json.encode({
          "auth_token": data['accessToken'],
          "id": data['data']['id'].toString(),
          "first_name": data['data']['first_name'],
          "last_name": data['data']['last_name'],
          "user_name": data['data']['user_name'],
          "email": data['data']['email'],
          "phone_no": data['data']['phone_no'],
          "created_at": data['data']['created_at']
        });

        prefs.setString('userData', userData);
      });

      return true;
    }).catchError((err) {
      throw err;
    });
    return false;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData') as String);
    _authToken = extractedUserData['auth_token'];
    _id = extractedUserData['id'];
    _firstName = extractedUserData['first_name'];
    _lastName = extractedUserData['last_name'];
    _username = extractedUserData['user_name'];
    _email = extractedUserData['email'];
    _phoneNumber = extractedUserData['phone_no'];
    _createdAt = extractedUserData['created_at'];

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _authToken = null;
    _id = null;
    _firstName = null;
    _lastName = null;
    _username = null;
    _email = null;
    _phoneNumber = null;
    _createdAt = null;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
