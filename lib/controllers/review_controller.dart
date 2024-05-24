import 'package:depanini/models/rating.dart';

class ReviewController {

  List<Rating> filterRatings(List<Rating> ratings) {
    Set<int> userIds = Set<int>(); // Set to store unique user IDs
    List<Rating> uniqueRatings = [];

    for (var rating in ratings) {
      if (!userIds.contains(rating.userId)) {
        // If the user ID is not in the set, add the rating and the user ID to the set
        uniqueRatings.add(rating);
        userIds.add(rating.userId!);
      }
    }

    return uniqueRatings;
  }
}


