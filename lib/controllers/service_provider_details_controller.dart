import 'package:depanini_front/models/serviceProvider.dart';
import 'package:depanini_front/services/serviceProvidersService.dart';
import 'package:depanini_front/views/chat/message_view.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceProviderDetailsController {
  final ServiceProvidersService _serviceProvidersService =ServiceProvidersService();
  
   Future<ServiceProvider>getProvider(id){
    return _serviceProvidersService.getProviderById(id);}
 

  Future<void> makePhoneCall(String phoneNumber, BuildContext context) async {
    final Uri _url = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(_url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch phone call'),
        ),
      );
    }
  }

  Future<void> sendMessage(BuildContext context) async {
    // Add your message functionality here
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessageView()),
    );
  }

  Future<bool> launchUrl(Uri url) async {
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
      return true;
    } else {
      return false;
    }
  }
}