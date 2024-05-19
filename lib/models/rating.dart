class Rating {
  final int id;
  final int workRating;
  final int disciplineRating;
  final int costRating;
  final String? comment;
  final String? reviewerName;
  final DateTime date;

  Rating(
      {required this.id,
      required this.workRating,
      required this.disciplineRating,
      required this.costRating,
      required this.comment,
      required this.reviewerName,
      required this.date}) {}
  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      workRating: json['workRating'],
      disciplineRating: json['disciplineRating'],
      costRating: json['costRating'],
      comment: json['comment'],
      reviewerName: json['user']['firstName'] + ' ' + json['user']['lastName'],
      date: DateTime.parse(json['date']),
    );
  }
}
