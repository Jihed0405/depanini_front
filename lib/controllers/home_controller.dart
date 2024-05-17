import 'package:depanini/models/rating.dart';
import 'package:depanini/models/serviceProvider.dart';
import 'package:depanini/services/ratingService.dart';
import 'package:depanini/services/serviceProvidersService.dart';
import 'package:flutter/material.dart';

class HomeController {
  final ServiceProvidersService _serviceProvidersService = ServiceProvidersService();
  final RatingService _ratingService = RatingService();

  Future<List<ServiceProvider>> getServiceProvidersMostQualified() async {
    return _serviceProvidersService.getServiceProvidersMostQualified();
  }

  Future<List<Rating>> getProvidersMostRated() async {
    return _ratingService.getProvidersMostRated();
  }
}