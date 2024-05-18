import 'dart:convert';
import 'package:depanini/models/rating.dart';

import 'package:http/http.dart' as http;

class RatingService {
  static const String baseUrl = 'http://192.168.1.52:8080/api/ratings';

  Future<List<Rating>> getRatingByProviderId(int id) async {

    final response = await http.get(Uri.parse('$baseUrl/$id/provider'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
print(jsonList.map((json) => Rating.fromJson(json)).toList());
      return jsonList.map((json) => Rating.fromJson(json)).toList();

    } else {
      throw Exception('Failed to load rating for this $id');
    }
  }

  Future<List<Rating>> getProvidersMostRated() async {
    final response = await http.get(Uri.parse('$baseUrl'));
    print("the ratings is ${response.body}");
    if (response.statusCode ==  200) {    
      final List<dynamic> jsonList =json.decode(response.body);   
      return jsonList.map((json) => Rating.fromJson(json)).toList();        
  }
  else {
      throw Exception('Failed to load most rated providers');
    }
}

}
