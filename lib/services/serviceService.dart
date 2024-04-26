import 'dart:convert';
import 'package:depanini_front/models/category.dart';
import 'package:depanini_front/models/serviceEntity.dart';
import 'package:http/http.dart' as http;

class ServiceService {
  static const String baseUrl = 'http://192.168.1.52:8080/api/categories';

  Future<List<ServiceEntity>> getServicesByCategoryId(int id) async {
    print('this is the fkn id $id');
    final response = await http.get(Uri.parse('$baseUrl/$id/services'));
print("the response is ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      print(  'we need ${ jsonList.map((json) => ServiceEntity.fromJson(json)).toList()}');
      return jsonList.map((json) => ServiceEntity.fromJson(json)).toList();

    } else {
      throw Exception('Failed to load Services');
    }
  }
}


