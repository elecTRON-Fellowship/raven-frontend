import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:raven/models/user_singleton.dart';

class RequestsSingleton {
  var userSingleton = UserDataSingleton();

  RequestsSingleton._internal();

  static final RequestsSingleton _singleton = RequestsSingleton._internal();

  factory RequestsSingleton() {
    return _singleton;
  }

  Future<http.Response> postReq() async {
    var url = Uri.parse('https://raven.herokuapp.com/cwallet');

    var response = await http.post(
      url,
      headers: {
        "user_id": userSingleton.getUserUid,
        "Content-Type": "application/json"
      },
      body: json.encode(userSingleton.toJson()),
    );

    return response;
  }
}
