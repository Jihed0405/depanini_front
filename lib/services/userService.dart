import 'dart:convert';
import 'package:depanini/models/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'http://192.168.1.52:8080/api/users';


  Future<User> getUserById(int id) async {

    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final  jsonList = json.decode(response.body);

      return  User.fromJson(jsonList);

    } else {
      throw Exception('Failed to load user');
    }
  }
  
}


