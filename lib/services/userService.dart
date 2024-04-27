import 'dart:convert';
import 'package:depanini_front/models/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'http://192.168.1.52:8080/api/users';


  Future<User> getUserById(int id) async {
    print('this is the user id $id');
    final response = await http.get(Uri.parse('$baseUrl/$id'));
print("the user testing now is ${response.body}");
    if (response.statusCode == 200) {
      final  jsonList = json.decode(response.body);
      print(  'we need ${ User.fromJson(jsonList)}');
      return  User.fromJson(jsonList);

    } else {
      throw Exception('Failed to load user');
    }
  }
  
}


