
import 'package:depanini_front/models/serviceProvider.dart';
import 'package:depanini_front/provider/provider.dart';
import 'package:depanini_front/services/serviceProvidersService.dart';
import 'package:depanini_front/widgets/ServiceProviderCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class ServiceProviderView extends ConsumerStatefulWidget {
  const ServiceProviderView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends ConsumerState<ServiceProviderView> {
  final ServiceProvidersService _serviceProvidersService = ServiceProvidersService();
  late Future<List<ServiceProvider>> _serviceProviderFuture;
   @override
  void initState() {
    super.initState();
    
  }
  
   @override
  Widget build(BuildContext context) {
        print("helllooo ${ref.watch(serviceIdProvider)}");
           print("the name is jihed  ${ref.watch(serviceNameProvider)}");
     _serviceProviderFuture = _serviceProvidersService.getProvidersByServiceId(ref.watch(serviceIdProvider));
    return Theme(
      data: Theme.of(context), // Inherit the theme from the parent context
      child: Scaffold(
        appBar: AppBar(
           centerTitle: true,
          title: Text('${ref.watch(serviceNameProvider)}',
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
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 20,
                right: 30,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Explore Service Providers",
                      style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
                    ),
                  ),
                
                ],
              ),
            ),
        
            FutureBuilder<List<ServiceProvider>>(
              future: _serviceProviderFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Padding(
                    padding: const EdgeInsets.only(left:32.0),
                    child: Center(
                      child: Text(
                          'Failed to load Service Providers. Please try again later.'),
                    ),
                  );
                } else {
                  final serviceProviderList = snapshot.data!;
      if(serviceProviderList.isEmpty){
       return Text("No service providers for this service  ");
      }
      else{
                      return SizedBox(
                        height: 1000,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: serviceProviderList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ServiceProviderCard(serviceProvider: serviceProviderList[index]),
                            );
                          },
                        ),
                      );}
                }
              },
            ),
            
          ],
        ),
      ),
    ),
      ),
    );
    
    
    
    }
    }