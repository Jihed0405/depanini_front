class Rating {
    final int id;
  final int workRating;
  final int disciplineRating ;
  final int costRating ;
  final  String ?comment;
 

  Rating({
    required this.id,
    required this.workRating,
    required this.disciplineRating,
    required this.costRating,
    required  this.comment
  }){}
  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      workRating: json['workRating'],
      disciplineRating: json['disciplineRating'],
     costRating: json['costRating'],
     comment: json['comment'],
    );
  }
}