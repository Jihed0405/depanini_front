import 'dart:convert';
import 'package:depanini_front/models/rating.dart';
import 'package:depanini_front/models/serviceEntity.dart';
import 'package:http/http.dart' as http;

class RatingService {
  static const String baseUrl = 'http://192.168.1.52:8080/api/ratings';

  Future<List<Rating>> getRatingByProviderId(int id) async {
    print('this is the rating for the  provider with id $id');
    final response = await http.get(Uri.parse('$baseUrl/$id/provider'));
print("the response is ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      print(  'we need ${ jsonList.map((json) => Rating.fromJson(json)).toList()}');
      return jsonList.map((json) => Rating.fromJson(json)).toList();

    } else {
      throw Exception('Failed to load rating for this $id');
    }
  }
}


