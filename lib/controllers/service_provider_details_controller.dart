import 'package:depanini/models/serviceProvider.dart';
import 'package:depanini/models/user.dart';
import 'package:depanini/services/serviceProvidersService.dart';
import 'package:depanini/views/chat/chat_view.dart';
import 'package:depanini/widgets/wrapperView.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:depanini/services/userService.dart';
import 'package:depanini/widgets/chatDetailScreen.dart';
class ServiceProviderDetailsController {
  final ServiceProvidersService _serviceProvidersService =
      ServiceProvidersService();
 final UserService _userService =
      UserService();
  Future<ServiceProvider> getProvider(id) {
    return _serviceProvidersService.getProviderById(id);
  }

  Future<void> makePhoneCall(String phoneNumber, BuildContext context) async {
    try {
      final Uri _url = Uri(scheme: 'tel', path: phoneNumber);
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch phone call');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch phone call'),
        ),
      );
    }
  }

  Future<void> sendMessage(BuildContext context,int id) async {
    User user = await _userService.getUserById(id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WrapperView(view: ChatDetailScreen(user: user))),
    );
  }
}
