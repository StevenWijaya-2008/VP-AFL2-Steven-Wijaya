import '../entities/drama.dart';

abstract class DramaRepository {
  Stream<List<Drama>> watchDramas();
  Future<List<Drama>> getDramas();
  Future<void> toggleBookmark(String dramaId);
  Future<void> updateWatchedEpisodes(String dramaId, int watchedEpisodes);
  void dispose();
}