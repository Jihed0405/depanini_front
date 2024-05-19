import 'dart:convert';

import 'package:depanini/constants/const.dart';
import 'package:depanini/models/serviceProvider.dart';
import 'package:http/http.dart' as http;

class ServiceProvidersService {
  static const String baseUrl = '$ipAddress/api/services';
  static const String baseProviderUrl =
      '$ipAddress/api/service-providers';

  Future<List<ServiceProvider>> getProvidersByServiceId(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id/providers'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);

      return jsonList.map((json) => ServiceProvider.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load providers of this service');
    }
  }

  Future<ServiceProvider> getProviderById(int id) async {
    final response = await http.get(Uri.parse('$baseProviderUrl/$id'));

    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body);

      return ServiceProvider.fromJson(jsonList);
    } else {
      throw Exception('Failed to load provider');
    }
  }

  Future<List<ServiceProvider>> getServiceProvidersMostQualified() async {
    final response =
        await http.get(Uri.parse('$baseProviderUrl/byRanking?minRanking=4'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);

      return jsonList.map((json) => ServiceProvider.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Service Providers most qualified');
    }
  }

  Future<List<ServiceProvider>> getAllServiceProviders() async {
    final response = await http.get(Uri.parse(baseProviderUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ServiceProvider.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Service Providers');
    }
  }
}
