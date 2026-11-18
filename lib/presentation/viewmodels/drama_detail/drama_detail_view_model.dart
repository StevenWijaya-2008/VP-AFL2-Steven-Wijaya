import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../domain/entities/drama.dart';
import '../../../domain/repositories/drama_repository.dart';
import 'drama_detail_state.dart';

class DramaDetailViewModel extends ChangeNotifier {
  final DramaRepository _repository;
  StreamSubscription<List<Drama>>? _subscription;
  Drama _currentDrama;
  DramaDetailState _state;
  bool _isDisposed = false;

  DramaDetailViewModel({
    required this. _repository,
    required Drama initialDrama,
  })  :_currentDrama = initialDrama,
        _state = DramaDetailLoaded(initialDrama) {
    _subscription = _repository.watchDramas().listen((dramas) {
      for (final item in dramas) {
        if (item.id == _currentDrama.id) {
          _currentDrama = item;
          if (!_isDisposed) {
            _state = DramaDetailLoaded(_currentDrama);
            notifyListeners();
          }
          break;
        }
      }
    });
  }

  DramaDetailState get state => _state;
  Drama get currentDrama => _currentDrama;

  Future<void> incrementEpisode() async {
    if (_currentDrama.watchedEpisodes >= _currentDrama.totalEpisodes) return;
    try {
      await _repository.updateWatchedEpisodes(
        _currentDrama.id,
        _currentDrama.watchedEpisodes + 1,
      );
    } catch (_) {
      if (_isDisposed) return;
      _state = const DramaDetailError(
        'Gagal menambah episode ditonton. Silakan coba lagi.',
      );
      notifyListeners();
    }
  }

  Future<void> toggleBookmark() async {
    try {
      await _repository.toggleBookmark(_currentDrama.id);
    } catch (_) {
      if (_isDisposed) return;
      _state = const DramaDetailError(
        'Gagal mengubah status bookmark. Silakan coba lagi.',
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _subscription?.cancel();
    super.dispose();
  }
}