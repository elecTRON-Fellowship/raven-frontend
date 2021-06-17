import 'package:http/http.dart' as http;
import 'package:raven/user_singleton.dart';

class RequestsSingleton {
  var userSingleton = UserDataSingleton();

  RequestsSingleton._internal();

  static final RequestsSingleton _singleton = RequestsSingleton._internal();

  factory RequestsSingleton() {
    return _singleton;
  }

  Future<http.Response> fetchAlbum() async {
    var url = Uri.parse('https://example.com/whatsit/create');
    var response = await http.post(url, body: userSingleton.toJson());
    return response;
  }
}
