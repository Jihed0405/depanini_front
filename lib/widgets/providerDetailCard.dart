import 'package:depanini_front/models/serviceProvider.dart';
import 'package:depanini_front/provider/provider.dart';
import 'package:depanini_front/views/serviceProvider/serviceProviderDetails_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProviderDetailCard extends ConsumerWidget {
  final ServiceProvider serviceProvider;

  const ProviderDetailCard({Key? key, required this.serviceProvider}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
   

    return Card(
      color:Colors.white70,
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Big photo on the left
            SizedBox(
              width: 100,
              height: 100,
              child: Image.asset(
                serviceProvider.photoUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.0),
            // Name, location, distance, stars, and commentary
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    serviceProvider.firstName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Location and distance
                  Row(
                    children: [
                      Text(serviceProvider.location),
                      SizedBox(width: 8.0),
                      Icon(Icons.location_on),
                      SizedBox(width: 4.0),
                      Text('${serviceProvider.distance} km'),
                    ],
                  ),
                  // Stars
                  Row(
                    children: List.generate(
                      serviceProvider.stars,
                      (index) => Icon(Icons.star, color:Color(0xFFebab01)),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Commentary
                  Text(serviceProvider.commentary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}