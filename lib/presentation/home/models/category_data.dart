class CategoryData<T> {
  final List<T> featured;
  final List<T> trending;
  final List<T> upcoming;

  CategoryData({
    required this.featured,
    required this.trending,
    required this.upcoming,
  });
}
