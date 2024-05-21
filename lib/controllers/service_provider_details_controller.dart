import 'package:depanini/models/serviceProvider.dart';
import 'package:depanini/services/serviceProvidersService.dart';
import 'package:depanini/views/chat/chat_view.dart';
import 'package:depanini/widgets/wrapperView.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceProviderDetailsController {
  final ServiceProvidersService _serviceProvidersService =
      ServiceProvidersService();

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

  Future<void> sendMessage(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WrapperView(view: ChatView())),
    );
  }
}
