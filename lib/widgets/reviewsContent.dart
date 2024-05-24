import 'package:depanini/controllers/review_controller.dart';
import 'package:depanini/controllers/service_provider_card_controller.dart';
import 'package:depanini/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:depanini/models/serviceProvider.dart';
import 'package:depanini/services/ratingService.dart';
import 'package:depanini/models/rating.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
final ReviewController _reviewController = ReviewController();
late List<Rating> _allRatings = [];
late List<Rating> clientRatings = [];
  @override
  void initState() {
    super.initState();
     super.initState();
    _ratingFuture = Future.delayed(Duration(seconds: 2), () async {
      List<Rating> ratings =
          await _ratingService.getRatingByProviderId(widget.serviceProvider.id);
      print('Fetched Ratings: ${ratings.length}');
      _allRatings = ratings; // Store all ratings
     clientRatings =
          _reviewController.filterRatings(ratings);
      print('Filtered Ratings Count: ${clientRatings.length}');
      return clientRatings;
    });
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
              return _buildNoRatingsCard();
            }

            double totalWorkRating = 0;
            double totalDisciplineRating = 0;
            double totalCostRating = 0;
            int overallRating = 0;

            for (var rating in clientRatings) {
              totalWorkRating += rating.workRating;
              totalDisciplineRating += rating.disciplineRating;
              totalCostRating += rating.costRating;
            }

            int totalReviewsClient = clientRatings.length;
            double averageWorkRating = totalWorkRating / totalReviewsClient;
            double averageDisciplineRating = totalDisciplineRating / totalReviewsClient;
            double averageCostRating = totalCostRating / totalReviewsClient;
            overallRating = _controller.calculateOverallRating(
                averageWorkRating.round(), averageDisciplineRating.round(), averageCostRating.round());
   int totalReviews = _allRatings.length;
           return _buildRatingCard(overallRating,totalReviews,averageWorkRating,averageDisciplineRating,averageCostRating,ratingList );
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
  
  Widget _buildNoRatingsCard() {
    return  Card(
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
                        SizedBox(height: 16),
                     ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 0, // Set itemCount to 0 initially
                    itemBuilder: (context, index) {
                      return Container(); // Return an empty container initially
                    },)
                    ],
                  ),
                ),
              );
  }
  
  Widget _buildRatingCard(int overallRating, int totalReviews, double averageWorkRating, double averageDisciplineRating, double averageCostRating, List<Rating> ratingList) {
      
    
      ratingList.sort((a, b) => b.date.compareTo(a.date));
        print("the list for test now is $ratingList");
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
                    _buildRatingRow('Quality of service', averageWorkRating.round()),
                    SizedBox(height: 8),
                    _buildRatingRow(
                        'Discipline Rating', averageDisciplineRating.round()),
                    SizedBox(height: 8),
                    _buildRatingRow('Fees of the service', averageCostRating.round()),
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
                    ), SizedBox(height: 16),
                // Place ListView.builder here
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: ratingList.length,
                  itemBuilder: (context, index) {
                    Rating rating = ratingList[index];
                      
            int overallRating = 0;
  print("see the rating is:${rating.photoUrl}");
         String? _comment = '';
         _comment = rating.comment;
            overallRating = _controller.calculateOverallRating(
                rating.workRating, rating.disciplineRating, rating.costRating);
                    // Display user comments with images, star ratings, and comments
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Row(
            children: [
                          // User image
                         ClipOval(
  child: CachedNetworkImage(
    imageUrl: rating.photoUrl!,
    width: 40, // Adjust the width of the image
    height: 40, // Adjust the height of the image
    fit: BoxFit.cover,
  ),
),
                          SizedBox(width: 8),
                           Text(
                rating.reviewerName!,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // Displaying the date
              ],
          ),
          SizedBox(height: 8),
          // Star ratings
                          // Star ratings
                          Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < overallRating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Color(0xFFebab01),
                                  );
                                }),
                              ),
                               SizedBox(width: 8),
                               Text(
                DateFormat.yMMMd().format(rating.date), // Format the date
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // User comment
                          Text(
                            _comment!,
                            style: TextStyle(fontSize: 16),
                          // Implement "show more" and "show less" for long comments
            maxLines: 3, // Show only 3 lines initially
            overflow: TextOverflow.ellipsis, // Overflow with ellipsis
          ),SizedBox(height: 8),
          // "Less" and "More" button
          TextButton(
            onPressed: () {
              // Implement your logic to toggle between "Less" and "More"
            },
            child: Text(
              'More', // Change to "Less" or "More" based on the state
              style: TextStyle(color: Colors.blue),
            ),
          ),
                          SizedBox(height: 16),
                        
                        ],),);}),
                   
                  ],
                ),
              ),
            );
  }
}
