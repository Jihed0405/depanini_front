  import 'package:depanini_front/models/serviceProvider.dart';
import 'package:depanini_front/widgets/ServiceProviderCard.dart';
import 'package:depanini_front/widgets/categories.dart';
import 'package:depanini_front/widgets/category_list_view.dart';
import 'package:flutter/material.dart';
List<ServiceProvider> serviceProviderList = [
  ServiceProvider(
    name: 'Service Provider 1',
    location: 'Location 1',
    distance: 2.5,
    stars: 4,
    image: 'assets/person/service_provider_1.jpg',
    commentary: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
  ),
  ServiceProvider(
    name: 'Service Provider 2',
    location: 'Location 2',
    distance: 3.2,
    stars: 5,
    image: 'assets/person/service_provider_2.jpg',
    commentary: 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  ),
  // Add more service providers as needed
];
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            // Title section
            Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.asset('assets/person/logo.png',width: 70,
                  height: 70,),
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
        'Find a Pro',
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
          return ServiceProviderCard(serviceProvider: serviceProviderList[index]);
        },
      ),
            ),
            ],
          )
    );
}

}