  import 'package:depanini_front/models/serviceProvider.dart';
import 'package:depanini_front/services/serviceProvidersService.dart';
import 'package:depanini_front/widgets/ServiceProviderCard.dart';
import 'package:depanini_front/widgets/categories.dart';
import 'package:depanini_front/widgets/category_list_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
   final ServiceProvidersService _serviceProvidersService = ServiceProvidersService();
  late Future<List<ServiceProvider>> _serviceProviderFuture;
  @override
  Widget build(BuildContext context) {
    _serviceProviderFuture = _serviceProvidersService.getServiceProviders();
    return SafeArea(



      
      child: 
           FutureBuilder<List<ServiceProvider>>(
            future: _serviceProviderFuture,
             builder: (context,snapshot){
               if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Text(
                        'Failed to load most qualified Service Providers. Please try again later.'),
                  );
                } else {final serviceProviderList = snapshot.data!;
          return
          Column(
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
            )
  
            ],
          );
          
                }
             }),
      
      
      
      
      
    );
}

}