import 'dart:convert';
import 'package:depanini_front/models/category.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  static const String baseUrl = 'http://192.168.1.52:8080/api/categories';

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
