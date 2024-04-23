import 'package:depanini_front/models/serviceProvider.dart';
import 'package:flutter/material.dart';

class ServiceProviderCard extends StatelessWidget {
  final ServiceProvider serviceProvider;

  const ServiceProviderCard({Key? key, required this.serviceProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber[50],
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
                serviceProvider.image,
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
                    serviceProvider.name,
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
                      (index) => Icon(Icons.star, color: Colors.yellow),
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