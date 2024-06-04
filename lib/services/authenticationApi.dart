import 'dart:convert';
import 'package:depanini/constants/const.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:depanini/provider/provider.dart';
class AuthenticationApi {
  static const String baseUrl = '$ipAddress/api/authentication';
   Future<Map<String,String>>signIn(String username, String password) async {
    final url = Uri.parse('$baseUrl/sign-in');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'username': username, 'password': password});

    try {
      final response = await http.post(url, headers: headers, body: body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final jwtToken = responseData['token'];
        final userType = responseData['user']['userType'];
        final userId = responseData['user']['id'];
        print(userId);
        return {'token': jwtToken, 'userType': userType,'userId':userId.toString()};
      } else {
       
        throw Exception('Failed to sign in');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<void> logoutUser(WidgetRef ref) async {
  final token = ref.watch(userTokenProvider);

  if (token == '') {
    return;
  }

  final response = await http.post(
    Uri.parse('$baseUrl/logout'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // Clear the token from the provider
    ref.read(userTokenProvider.notifier).add('null');
    print("loged out succ ${ref.watch(userTokenProvider)}");

    // Handle post-logout actions, like navigation
  } else {
    // Handle error
    print('Failed to logout: ${response}');
  }
}
}
