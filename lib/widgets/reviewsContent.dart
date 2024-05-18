import 'package:depanini/controllers/service_provider_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:depanini/models/serviceProvider.dart';
import 'package:depanini/services/ratingService.dart';
import 'package:depanini/models/rating.dart';
import 'package:shimmer/shimmer.dart';

class ReviewsContent extends StatefulWidget {
  final ServiceProvider serviceProvider;

  ReviewsContent({required this.serviceProvider});

  @override
  _ReviewsContentState createState() => _ReviewsContentState();
}

class _ReviewsContentState extends State<ReviewsContent> {
  final RatingService _ratingService = RatingService();
  late Future<List<Rating>> _ratingFuture;
  final ServiceProviderCardController _controller = ServiceProviderCardController();

  @override
  void initState() {
    super.initState();
    _ratingFuture = _ratingService.getRatingByProviderId(widget.serviceProvider.id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<Rating>>(
        future: _ratingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingPlaceholder();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load reviews. Please try again later.'),
            );
          } else {
            final ratingList = snapshot.data!;
            if (ratingList.isEmpty) {
              return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clients rate',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "0", // Average star rating
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return Icon(
                                index < 0 ? Icons.star : Icons.star_border,
                                color: Color(0xFFebab01),
                              );
                            }),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '0 notes', // Number of reviews
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildRatingRow('Quality of service', 0),
                    SizedBox(height: 8),
                    _buildRatingRow('Discipline Rating', 0),
                    SizedBox(height: 8),
                    _buildRatingRow('Fees of the service', 0),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Add your rating functionality here
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFebab01),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Add Rate',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
            }

            double totalWorkRating = 0;
            double totalDisciplineRating = 0;
            double totalCostRating = 0;
            int overallRating = 0;

            for (var rating in ratingList) {
              totalWorkRating += rating.workRating;
              totalDisciplineRating += rating.disciplineRating;
              totalCostRating += rating.costRating;
            }

            int totalReviews = ratingList.length;
            int averageWorkRating = totalWorkRating  ~/ totalReviews ;
            int averageDisciplineRating = totalDisciplineRating ~/ totalReviews;
            int averageCostRating = totalCostRating  ~/ totalReviews;
            overallRating = _controller.calculateOverallRating(averageWorkRating,averageDisciplineRating,averageCostRating);

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clients rate',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            overallRating.toStringAsFixed(1), // Average star rating
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return Icon(
                                index < overallRating ? Icons.star : Icons.star_border,
                                color: Color(0xFFebab01),
                              );
                            }),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '$totalReviews notes', // Number of reviews
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildRatingRow('Quality of service', averageWorkRating),
                    SizedBox(height: 8),
                    _buildRatingRow('Discipline Rating', averageDisciplineRating),
                    SizedBox(height: 8),
                    _buildRatingRow('Fees of the service', averageCostRating),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Add your rating functionality here
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFebab01),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Add Rate',
                          style: TextStyle(color: Colors.white),
                        ),
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

  Widget _buildRatingRow(String title, int rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < rating ? Icons.star : Icons.star_border,
              color: Color(0xFFebab01),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                height: 24,
                color: Colors.grey[300],
              ),
              SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 24,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(Icons.star, color: Colors.grey[300]);
                      }),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 100,
                      height: 16,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              _buildLoadingRatingRow(),
              SizedBox(height: 8),
              _buildLoadingRatingRow(),
              SizedBox(height: 8),
              _buildLoadingRatingRow(),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 48,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingRatingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 150,
          height: 16,
          color: Colors.grey[300],
        ),
        Row(
          children: List.generate(5, (index) {
            return Icon(Icons.star, color: Colors.grey[300]);
          }),
        ),
      ],
    );
  }
}
