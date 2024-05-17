import 'package:depanini/constants/size.dart';
import 'package:depanini/models/category.dart';
import 'package:depanini/provider/provider.dart';
import 'package:depanini/views/search/search_view.dart';
import 'package:depanini/views/service/service_view.dart';
import 'package:depanini/views/serviceProvider/serviceProvider_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceCard extends ConsumerStatefulWidget {
  final  service;
  
  const ServiceCard({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends ConsumerState<ServiceCard> {
  @override
  Widget build(BuildContext context) {
    print("providers${ref.watch(serviceIdProvider)}");
    print("providers${ref.watch(serviceNameProvider)}");
    return GestureDetector(
      onTap: () {
 
        String name = widget.service.name!;
       
        int serviceId = widget.service.id!;
        
        ref.read(serviceIdProvider.notifier).add(serviceId);
        ref.read(serviceNameProvider.notifier).add(name);
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ServiceProviderView()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 4.0,
              spreadRadius: .05,
            ),
          ],
          border: Border.all(
            color: Colors.grey, // Border color
            width: 1, // Border width
          ),
        ),
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              widget.service.imagePath,
              height: 60,
            ),
            SizedBox(height: 5),
            Text(
              widget.service.name,
              maxLines: 2, // Limit to 2 lines
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
