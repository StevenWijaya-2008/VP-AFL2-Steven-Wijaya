import '../../domain/entities/drama.dart';

class DramaModel extends Drama {
  const DramaModel({
    required super.id,
    required super.title,
    required super.genre,
    required super.totalEpisodes,
    required super.watchedEpisodes,
    super.rating,
    super.origin,
    super.synopsis,
    super.tags,
    super.imageUrl,
    super.isBookmarked,
  });

  factory DramaModel.fromJson(Map<String, dynamic> json) {
    return DramaModel(
      id: json['id'] as String,
      title: json['title'] as String,
      genre: json['genre'] as String,
      totalEpisodes: (json['totalEpisodes'] as num).toInt(),
      watchedEpisodes: (json['watchedEpisodes'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      origin: json['origin'] as String? ?? 'K-Drama',
      synopsis: json['synopsis'] as String? ?? '',
      tags: List<String>.from(json['tags'] ?? const []),
      imageUrl: json['imageUrl'] as String? ?? '',
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }

  factory DramaModel.fromEntity(Drama drama) {
    return DramaModel(
      id: drama.id,
      title: drama.title,
      genre: drama.genre,
      totalEpisodes: drama.totalEpisodes,
      watchedEpisodes: drama.watchedEpisodes,
      rating: drama.rating,
      origin: drama.origin,
      synopsis: drama.synopsis,
      tags: drama.tags,
      imageUrl: drama.imageUrl,
      isBookmarked: drama.isBookmarked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'totalEpisodes': totalEpisodes,
      'watchedEpisodes': watchedEpisodes,
      'rating': rating,
      'origin': origin,
      'synopsis': synopsis,
      'tags': tags,
      'imageUrl': imageUrl,
      'isBookmarked': isBookmarked,
    };
  }
}