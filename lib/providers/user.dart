import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User with ChangeNotifier {
  String? _authToken;
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _username;
  String? _email;
  String? _phoneNumber;
  String? _createdAt;

  Map<String, String?> get user {
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

  Future<void> register(String firstName, String lastName, String username,
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
    }).catchError((err) {
      throw err;
    });
  }
}
