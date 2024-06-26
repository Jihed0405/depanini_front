import 'package:depanini/controllers/home_controller.dart';
import 'package:depanini/models/serviceProvider.dart';
import 'package:depanini/services/network_service.dart';

import 'package:depanini/widgets/ServiceProviderCard.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController _homeController = HomeController();
  late Future<List<ServiceProvider>> _serviceProviderFuture;
  final NetworkService _networkService = NetworkService();

  @override
  void initState() {
    super.initState();
    _checkInternetAndShowSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    _serviceProviderFuture = _homeController.getServiceProvidersMostQualified();
    return SafeArea(
      child: FutureBuilder<List<ServiceProvider>>(
        future: _serviceProviderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Center(
                child: Text(
                  'Failed to load most qualified Service Providers. Please try again later.'),
              ),
            );
          } else {
            final serviceProviderList = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title section
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/person/logo.png',
                        width: 70,
                        height: 70,
                      ),
                      Text(
                        'Depanini',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Most qualified Providers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Service provider cards
                Expanded(
                  child: ListView.builder(
                    itemCount: serviceProviderList.length,
                    itemBuilder: (context, index) {
                      return ServiceProviderCard(
                        serviceProvider: serviceProviderList[index],
                      );
                    },
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> _checkInternetAndShowSnackBar(BuildContext context) async {
    final hasInternet = await _networkService.checkInternetConnection();
        print("connextio nstate is $hasInternet");
    if (!hasInternet) {
      _showNoInternetSnackBar(context);
    }
  }

  void _showNoInternetSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'No internet connection',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
