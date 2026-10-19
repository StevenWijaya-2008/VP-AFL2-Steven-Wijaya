class Drama {
  final String id;
  final String title;
  final String genre;
  final int totalEpisodes;
  final int watchedEpisodes;
  final double rating;
  final String origin;
  final String synopsis;
  final List<String> tags;
  final String imageUrl;
  final bool isBookmarked;

  const Drama({
    required this.id,
    required this.title,
    required this.genre,
    required this.totalEpisodes,
    required this.watchedEpisodes,
    this.rating = 0.0,
    this.origin = 'K-Drama',
    this.synopsis = '',
    this.tags = const [],
    this.imageUrl = '',
    this.isBookmarked = false,
  });

  Drama copyWith({
    String? id,
    String? title,
    String? genre,
    int? totalEpisodes,
    int? watchedEpisodes,
    double? rating,
    String? origin,
    String? synopsis,
    List<String>? tags,
    String? imageUrl,
    bool? isBookmarked,
  }) {
    return Drama(
      id: id ?? this.id,
      title: title ?? this.title,
      genre: genre ?? this.genre,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
      watchedEpisodes: watchedEpisodes ?? this.watchedEpisodes,
      rating: rating ?? this.rating,
      origin: origin ?? this.origin,
      synopsis: synopsis ?? this.synopsis,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}