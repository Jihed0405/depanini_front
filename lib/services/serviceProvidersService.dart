import 'dart:convert';


import 'package:depanini_front/models/serviceProvider.dart';
import 'package:http/http.dart' as http;

class ServiceProvidersService {
  static const String baseUrl = 'http://192.168.1.52:8080/api/services';
  static const String baseProviderUrl = 'http://192.168.1.52:8080/api/service-providers';
  
  Future<List<ServiceProvider>> getProvidersByServiceId(int id) async {
    print('this is the service id $id');
    final response = await http.get(Uri.parse('$baseUrl/$id/providers'));
print("the response is ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      print(  'we need ${ jsonList.map((json) => ServiceProvider.fromJson(json)).toList()}');
      return jsonList.map((json) => ServiceProvider.fromJson(json)).toList();

    } else {
      throw Exception('Failed to load providers of this service');
    }
  }

  Future<ServiceProvider> getProviderById(int id) async {
    print('this is the provider id $id');
    final response = await http.get(Uri.parse('$baseProviderUrl/$id'));
print("the provider testing now is ${response.body}");
    if (response.statusCode == 200) {
      final  jsonList = json.decode(response.body);
      print(  'we need ${ ServiceProvider.fromJson(jsonList)}');
      return  ServiceProvider.fromJson(jsonList);

    } else {
      throw Exception('Failed to load provider');
    }
  }
   Future<List<ServiceProvider>> getServiceProviders() async {
    final response = await http.get(Uri.parse(baseProviderUrl));
print("the all providers response is ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ServiceProvider.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Service Providers');
    }
  }
}


