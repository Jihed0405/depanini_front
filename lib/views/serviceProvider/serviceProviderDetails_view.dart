import 'package:depanini_front/models/serviceProvider.dart';
import 'package:depanini_front/provider/provider.dart';
import 'package:depanini_front/services/serviceProvidersService.dart';
import 'package:depanini_front/widgets/ProviderDetailCard.dart';
import 'package:depanini_front/widgets/ServiceProviderCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceProviderDetailsView extends ConsumerStatefulWidget {
  const ServiceProviderDetailsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServiceProviderDetailsViewState();
}

class _ServiceProviderDetailsViewState extends ConsumerState<ServiceProviderDetailsView> {
 final ServiceProvidersService _serviceProvidersService = ServiceProvidersService();
  late Future<ServiceProvider> _serviceProviderFuture;
  @override
  Widget build(BuildContext context) {
     _serviceProviderFuture = _serviceProvidersService.getProviderById(ref.watch(serviceProviderIdProvider));
return Theme(
      data: Theme.of(context), // Inherit the theme from the parent context
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('${ref.watch(serviceProviderNameProvider)}',
             style: TextStyle(
              
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ))
        ),
        body: SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0,left: 16.0),
                  child: Text(
                    "Details ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              
              ],
            ),
        
      FutureBuilder<ServiceProvider>(
              future: _serviceProviderFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Text(
                        'Failed to load Provider. Please try again later.'),
                  );
                } else {
                  final serviceProvider = snapshot.data;
      if(serviceProvider == null){
       return Text("No service providers for this service ");
      }
      else{
                      return SizedBox(
                        height: 250,
                        child:  ProviderDetailCard(serviceProvider: serviceProvider),);
                          
                        
                      }
                }
              },
            ),
             const SizedBox(height: 30),
          ],
        ),
      ),
    ),
      ),
    );
    
    
  }
}