class RatingEntry {
  final int score;
  final String? comment;

  const RatingEntry({
    required this.score,
    this.comment,
  });

  bool get isValid => score >= 1 && score <= 5;
}
