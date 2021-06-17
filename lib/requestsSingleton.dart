import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:raven/user_singleton.dart';

class RequestsSingleton {
  var userSingleton = UserDataSingleton();

  RequestsSingleton._internal();

  static final RequestsSingleton _singleton = RequestsSingleton._internal();

  factory RequestsSingleton() {
    return _singleton;
  }

  Future<http.Response> postReq() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/todos/1');

    var response = await http.post(url,
        headers: {"user_uid": userSingleton.getUserUid},
        body: json.encode(userSingleton.toJson()));

    return response;
  }
}
