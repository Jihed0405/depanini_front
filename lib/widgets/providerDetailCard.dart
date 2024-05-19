import 'package:cached_network_image/cached_network_image.dart';
import 'package:depanini/controllers/service_provider_card_controller.dart';
import 'package:depanini/models/rating.dart';
import 'package:depanini/models/serviceProvider.dart';
import 'package:depanini/services/ratingService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class ProviderDetailCard extends ConsumerStatefulWidget {
  final ServiceProvider serviceProvider;

  ProviderDetailCard({Key? key, required this.serviceProvider})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ServiceProviderDetailsViewState();
}

class _ServiceProviderDetailsViewState
    extends ConsumerState<ProviderDetailCard> {
  final RatingService _ratingService = RatingService();
  late Future<List<Rating>> _ratingFuture;
  final ServiceProviderCardController _controller =
      ServiceProviderCardController();

  @override
  void initState() {
    super.initState();
    final _providerId = widget.serviceProvider.id;
    _ratingFuture = Future.delayed(Duration(seconds: 2),
        () => _ratingService.getRatingByProviderId(_providerId));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<Rating>>(
        future: _ratingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return detailsCardOnload();
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Center(
                child: Text(
                    'Failed to load  details of Service Providers. Please try again later.'),
              ),
            );
          } else {
            final ratingList = snapshot.data!;
            String _comment = '';
            int totalStar = 0;
            for (var rating in ratingList) {
              _comment = rating.comment!;
              totalStar += _controller.calculateOverallRating(
                rating.workRating,
                rating.disciplineRating,
                rating.costRating,
              );
            }

            int starsToShow = totalStar < 0 ? 0 : totalStar;
            return Card(
              color: Colors.white70,
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
                      child: CachedNetworkImage(
                        imageUrl: widget.serviceProvider.photoUrl,
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
                            '${widget.serviceProvider.firstName} ${widget.serviceProvider.lastName}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.serviceProvider.address} ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          // Stars
                          Row(children: [
                            ...List.generate(
                              starsToShow > 5 ? 0 : starsToShow,
                              (index) =>
                                  Icon(Icons.star, color: Color(0xFFebab01)),
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
          }
        },
      ),
    );
  }
}

class detailsCardOnload extends StatelessWidget {
  const detailsCardOnload({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        color: Colors.white10,
        margin: EdgeInsets.all(16.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shimmer for photo
              SizedBox(
                width: 100,
                height: 100,
                child: Container(color: Colors.grey),
              ),
              SizedBox(width: 16.0),
              // Shimmer for text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 18.0,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8.0),
                    Container(
                      width: 170,
                      height: 18.0,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8.0),
                    // Stars
                    Row(
                      children: [
                        // Shimmer for stars
                        for (int i = 0; i < 5; i++)
                          Icon(Icons.star, color: Colors.grey),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    // Shimmer for commentary
                    Container(
                      width: 170,
                      height: 18.0,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
