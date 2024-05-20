import 'package:depanini/controllers/service_provider_card_controller.dart';
import 'package:depanini/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:depanini/models/serviceProvider.dart';
import 'package:depanini/services/ratingService.dart';
import 'package:depanini/models/rating.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewsContent extends ConsumerStatefulWidget {
  final ServiceProvider serviceProvider;

  ReviewsContent({required this.serviceProvider});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReviewsContentState();
}

class _ReviewsContentState extends ConsumerState<ReviewsContent> {
  final RatingService _ratingService = RatingService();
  late Future<List<Rating>> _ratingFuture;
  final ServiceProviderCardController _controller =
      ServiceProviderCardController();

  @override
  void initState() {
    super.initState();
    _ratingFuture = Future.delayed(Duration(seconds: 2),
        () => _ratingService.getRatingByProviderId(widget.serviceProvider.id));
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
                          onPressed: () {},
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
            int averageWorkRating = totalWorkRating ~/ totalReviews;
            int averageDisciplineRating = totalDisciplineRating ~/ totalReviews;
            int averageCostRating = totalCostRating ~/ totalReviews;
            overallRating = _controller.calculateOverallRating(
                averageWorkRating, averageDisciplineRating, averageCostRating);

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
                            overallRating
                                .toStringAsFixed(1), // Average star rating
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return Icon(
                                index < overallRating
                                    ? Icons.star
                                    : Icons.star_border,
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
                    _buildRatingRow(
                        'Discipline Rating', averageDisciplineRating),
                    SizedBox(height: 8),
                    _buildRatingRow('Fees of the service', averageCostRating),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showRatingModal(context, widget.serviceProvider);
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
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 24,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(Icons.star, color: Colors.grey);
                      }),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 60,
                      height: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildLoadingRatingRow('Quality of service'),
            SizedBox(height: 8),
            _buildLoadingRatingRow('Discipline Rating'),
            SizedBox(height: 8),
            _buildLoadingRatingRow('Fees of the service'),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  print("here we go rating create now ");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFFebab01), // Set button color to theme color
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

  Widget _buildLoadingRatingRow(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            children: List.generate(5, (index) {
              return Icon(Icons.star, color: Colors.grey);
            }),
          ),
        ),
      ],
    );
  }

  void _showRatingModal(BuildContext context, ServiceProvider serviceProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double qualityOfService = 0;
        double disciplineRating = 0;
        double feesOfService = 0;
        TextEditingController commentController = TextEditingController();

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context, serviceProvider, qualityOfService,
              disciplineRating, feesOfService, commentController),
        );
      },
    ).then((result) {
      if (result != null) {
       
        if (result['qualityOfService'] == 0 &&
            result['disciplineRating'] == 0 &&
            result['feesOfService'] == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'You chose to provide zero ratings for all categories.')),
          );
        }
        if (result['comment'].isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You added a rating with no comments.')),
          );
        }
        else   if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review added successfully.')),
        );
      }
      }
    });
  }

  Widget contentBox(
      BuildContext context,
      ServiceProvider serviceProvider,
      double qualityOfService,
      double disciplineRating,
      double feesOfService,
      TextEditingController commentController) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${serviceProvider.firstName} ${serviceProvider.lastName}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              _buildRatingRowModal('Quality of service', qualityOfService,
                  (rating) {
                qualityOfService = rating;
              }),
              SizedBox(height: 8),
              _buildRatingRowModal('Discipline Rating', disciplineRating,
                  (rating) {
                disciplineRating = rating;
              }),
              SizedBox(height: 8),
              _buildRatingRowModal('Fees of the service', feesOfService,
                  (rating) {
                feesOfService = rating;
              }),
              SizedBox(height: 16),
              Flexible(
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Tap to add a comment',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  maxLines: 3,
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.grey,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      bool success = await saveRating(qualityOfService, disciplineRating,
                          feesOfService, commentController.text);

                      Navigator.of(context).pop({
                        'qualityOfService': qualityOfService,
                        'disciplineRating': disciplineRating,
                        'feesOfService': feesOfService,
                        'comment': commentController.text,
                        'success': success,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFebab01),
                    ),
                    child: Text(
                      'Save Rate',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingRowModal(String title, double initialRating,
      void Function(double) onRatingUpdate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        SizedBox(height: 4),
        RatingBar.builder(
          initialRating: initialRating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
          itemBuilder: (context, index) => Icon(
            index < initialRating ? Icons.star : Icons.star_border,
            color: Color(0xFFebab01),
          ),
          onRatingUpdate: (rating) {
            setState(() {
              initialRating = rating;
            });
            onRatingUpdate(rating);
          },
          unratedColor: Colors.grey,
        ),
      ],
    );
  }

  Future<bool> saveRating(double qualityOfService, double disciplineRating,
      double feesOfService, String comment) async {
    Rating newRating = Rating(
      id: 0, // ID should be generated by the backend
      workRating: qualityOfService.toInt(),
      disciplineRating: disciplineRating.toInt(),
      costRating: feesOfService.toInt(),
      comment: comment,

      serviceProviderId: widget.serviceProvider.id,
      userId: ref.watch(userIdProvider), // Update with the actual user ID
      date: DateTime.now(),
    );

    try {
      Rating createdRating = await _ratingService.addRate(newRating);
      setState(() {
        _ratingFuture = Future.delayed(
            Duration(seconds: 2),
            () => _ratingService
                .getRatingByProviderId(widget.serviceProvider.id));
      });
      return true; 
    } catch (e) {
      print('Failed to create a rate for a provider: $e');
      return false;
    }
  }
}
