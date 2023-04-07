import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:voting/user.dart';

class Requests{
  static const baseUrl = 'http://192.168.8.108:8000/api/';
  static const storage = FlutterSecureStorage();
  static Uri getUrl(String url) => Uri.parse(baseUrl+url);

  static Future<Object> getRules() async {
    try {
      final response = await http.get(getUrl('getRules'));
      return jsonDecode(response.body) as List<dynamic>;
    } catch(e) {
      return e.toString();
    }
  }

  static Future<Map<String, Object>> login(Map<String, String> credentials) async {
    try {
      var response = await http.post(
          getUrl('login'),
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
            'X-Requested-With': 'XMLHttpRequest'
          },
          body: jsonEncode(credentials));
      return {'error':false, 'res':response.body, 'code':response.statusCode};
    } catch(e) {
      return {'error':true, 'res':e.toString()};
    }
  }

  static void storageWrite(String key, String value) async {
    await storage.write(key: 'token', value: value);
  }

  static Future<String?> storageRead(String key) async{
    return await storage.read(key: key);
  }

  static Future<bool> isAuthenticated() async {
    if(await storage.containsKey(key: 'token')){
      final token = await storage.read(key: 'token');
      try {
        var response = await http.get(
            getUrl('user'),
            headers: {
              "Content-type": "application/json",
              "Accept": "application/json",
              'X-Requested-With': 'XMLHttpRequest',
              'Authorization': 'Bearer $token',
            });
        if(response.statusCode==200){
          final user = jsonDecode(response.body);
          User.id = user['id'];
          User.token = token;
          User.email = user['email'].toString();
          User.name = user['name'].toString();
          User.studentNo = user['student_no'].toString();
          return true;
        }
        await storage.delete(key: 'token');
        return false;
      } catch(e) {
        return false;
      }
    }
    return false;
  }

}
