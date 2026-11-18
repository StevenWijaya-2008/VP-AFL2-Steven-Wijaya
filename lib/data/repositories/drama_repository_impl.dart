import 'dart:async';
import '../../domain/entities/drama.dart';
import '../../domain/repositories/drama_repository.dart';
import '../models/drama_model.dart';
import '../services/drama_service.dart';

class DramaRepositoryImpl implements DramaRepository {
  final DramaService _service;
  final StreamController<List<Drama>> _dramasController =
  StreamController<List<Drama>>.broadcast();

  List<Drama> _cachedDramas = [];

  DramaRepositoryImpl(this._service);

  @override
  Stream<List<Drama>> watchDramas() => _dramasController.stream;

  @override
  Future<List<Drama>> getDramas() async {
    final rawList = await _service.fetchRawDramas();
    _cachedDramas = rawList.map((json) => DramaModel.fromJson(json)).toList();
    _dramasController.add(List.unmodifiable(_cachedDramas));
    return List.unmodifiable(_cachedDramas);
  }

  @override
  Future<void> toggleBookmark(String dramaId) async {
    if (_cachedDramas.isEmpty) {
      await getDramas();
    }

    _cachedDramas = _cachedDramas.map((drama) {
      if (drama.id == dramaId) {
        return drama.copyWith(isBookmarked: !drama.isBookmarked);
      }
      return drama;
    }).toList();

    await _persistAndNotify();
  }

  @override
  Future<void> updateWatchedEpisodes(String dramaId, int watchedEpisodes) async {
    if (_cachedDramas.isEmpty) {
      await getDramas();
    }

    _cachedDramas = _cachedDramas.map((drama) {
      if (drama.id == dramaId) {
        final clampedEpisodes = watchedEpisodes.clamp(0, drama.totalEpisodes);
        return drama.copyWith(watchedEpisodes: clampedEpisodes);
      }
      return drama;
    }).toList();

    await _persistAndNotify();
  }

  Future<void> _persistAndNotify() async {
    final rawList = _cachedDramas
        .map((drama) => DramaModel.fromEntity(drama).toJson())
        .toList();

    await _service.saveRawDramas(rawList);
    _dramasController.add(List.unmodifiable(_cachedDramas));
  }

  @override
  void dispose() {
    _dramasController.close();
  }
}