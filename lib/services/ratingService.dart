import 'dart:convert';
import 'package:depanini/constants/const.dart';
import 'package:depanini/models/rating.dart';

import 'package:http/http.dart' as http;

class RatingService {
  static const String baseUrl = '$ipAddress/api/ratings';

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

  Future<List<Rating>> getProvidersRated() async {
    final response = await http.get(Uri.parse('$baseUrl/create'));
    print("the ratings is ${response.body}");
    if (response.statusCode == 201) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Rating.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load rated providers');
    }
  }
   Future<Rating> addRate(Rating rating) async {
    final Map<String, dynamic> data = rating.toJson();

    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    print("the response is ${response.body}");

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return Rating.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create a rate for a provider');
    }
  }
}
