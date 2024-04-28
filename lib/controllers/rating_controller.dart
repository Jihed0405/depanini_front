class RatingController{
int calculateOverallRating(int workRating, int disciplineRating,int costRating) {
   
    double workWeight = 0.4;
    double disciplineWeight = 0.3;
    double costWeight = 0.3;


    double weightedWorkRating = workRating * workWeight;
    double weightedDisciplineRating = disciplineRating * disciplineWeight;
    double weightedCostRating = costRating * costWeight;

  
    double totalWeightedSum =
        weightedWorkRating + weightedDisciplineRating + weightedCostRating;


    double overallRatingDouble = totalWeightedSum /
        (workWeight + disciplineWeight + costWeight);


    int overallRating = overallRatingDouble.round();

    return overallRating;
  }
}