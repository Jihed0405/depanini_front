

import 'package:depanini_front/controllers/rating_controller.dart';
import 'package:depanini_front/models/rating.dart';
import 'package:depanini_front/models/serviceProvider.dart';
import 'package:depanini_front/services/ratingService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProviderDetailCard extends ConsumerStatefulWidget {
  late ServiceProvider serviceProvider;
 ProviderDetailCard({Key? key, required this.serviceProvider}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServiceProviderDetailsViewState();}
  class _ServiceProviderDetailsViewState extends ConsumerState<ProviderDetailCard> {
  
 final RatingService _ratingService = RatingService();
  late Future<List<Rating>> _ratingFuture;
  final RatingController _ratingController = RatingController();
    @override
  void initState() {
    super.initState();
    final _providerId = widget.serviceProvider.id!;
    _ratingFuture = _ratingService.getRatingByProviderId(_providerId);
  }

  @override
  Widget build(BuildContext context) {
  
  
return SafeArea(
  child: FutureBuilder<List<Rating>>(
  
       future: _ratingFuture,
               builder: (context,snapshot){
                 if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }  else if (snapshot.hasError) {
                
                    return Padding(
                      padding: const EdgeInsets.only(left:32.0),
                      child: Center(
                        child: Text(
                            'Failed to load  details of Service Providers. Please try again later.'),
                      ),
                    );
                  }else {final ratingList = snapshot.data!;
                 String _comment ='';
                    int totalStar=0;
                 for (var rating in ratingList) {
_comment = rating.comment!;
  totalStar += _ratingController.calculateOverallRating(
    rating.workRating,
    rating.disciplineRating,
    rating.costRating,
  );
}

                  
                  
                   int starsToShow = totalStar < 0 ? 0 : totalStar;
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
                  widget.serviceProvider.photoUrl,
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
                     widget.serviceProvider.firstName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Location and distance
                    Row(
                      children: [
                         Text(widget.serviceProvider?.address??""),
                        SizedBox(width: 8.0),
                        Icon(Icons.location_on),
                        SizedBox(width: 4.0),
                        Text('${widget.serviceProvider.distance} km'),
                      ],
                    ),
                    // Stars
                  Row(children: [
                        ...List.generate(
                          starsToShow > 5 ? 0 : starsToShow,
                          (index) => Icon(Icons.star, color: Color(0xFFebab01)),
                        ),
                        ...List.generate(
                          starsToShow > 5 ? 5 : 5 - starsToShow,
                          (index) => Icon(Icons.star, color: Colors.grey),
                        ),
                      ]),
                    SizedBox(height: 8.0),
                    // Commentary
                    Text(_comment),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
                  
                  }}),
);
   
   
  }
  
 
}