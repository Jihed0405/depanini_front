  import 'package:depanini_front/models/serviceProvider.dart';
import 'package:depanini_front/widgets/ServiceProviderCard.dart';
import 'package:depanini_front/widgets/categories.dart';
import 'package:depanini_front/widgets/category_list_view.dart';
import 'package:flutter/material.dart';
List<ServiceProvider> serviceProviderList = [
  ServiceProvider(
    id:0,
    lastName:"Darryl Depanini",
    firstName: 'Service Provider 1',
    
    photoUrl: 'assets/person/service_provider_1.jpg',
     email: 'ded@fefeef', phoneNumber: '94515151', bio: 'deeddeffef', numberOfExperiences: 10,
  ),
  ServiceProvider(
    firstName: 'Service Provider 2',
  
    photoUrl: 'assets/person/service_provider_2.jpg',
 id: 1, lastName: '', email: '@gmail.com', phoneNumber: '9899999', bio: 'eddeded', numberOfExperiences: 10,
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
          return ServiceProviderCard(serviceProvider: serviceProviderList[index]);
        },
      ),
            ),
            ],
          )
    );
}

}