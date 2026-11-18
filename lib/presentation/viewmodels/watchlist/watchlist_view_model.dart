import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../domain/entities/drama.dart';
import '../../../domain/repositories/drama_repository.dart';
import 'watchlist_state.dart';

class WatchlistViewModel extends ChangeNotifier {
  final DramaRepository _repository;
  StreamSubscription<List<Drama>>? _subscription;

  WatchlistState _state = const WatchlistInitial();
  List<Drama> _allDramas = [];
  String _query = '';
  bool _isDisposed = false;

  WatchlistViewModel(this._repository) {
    _subscription = _repository.watchDramas().listen((dramas) {
      _allDramas = dramas;
      _emitLoaded();
    });
  }

  WatchlistState get state => _state;

  List<Drama> get _bookmarkedDramas =>
      _allDramas.where((drama) => drama.isBookmarked).toList();

  List<Drama> get _visibleDramas {
    return _bookmarkedDramas.where((drama) {
      return _query.isEmpty ||
          drama.title.toLowerCase().contains(_query.toLowerCase());
    }).toList();
  }

  void _emitLoaded() {
    if (_isDisposed) return;
    final bookmarked = _bookmarkedDramas;
    final completed = bookmarked
        .where((d) => d.totalEpisodes > 0 && d.watchedEpisodes >= d.totalEpisodes)
        .length;
    final watching = bookmarked
        .where((d) => d.watchedEpisodes > 0 && d.watchedEpisodes < d.totalEpisodes)
        .length;

    _state = WatchlistLoaded(
      visibleDramas: _visibleDramas,
      query: _query,
      completedCount: completed,
      watchingCount: watching,
    );
    notifyListeners();
  }

  Future<void> loadWatchlist() async {
    _state = const WatchlistLoading();
    notifyListeners();

    try {
      _allDramas = await _repository.getDramas();
      if (_isDisposed) return;
      _emitLoaded();
    } catch (_) {
      if (_isDisposed) return;
      _state = const WatchlistError(
        'Gagal memuat daftar watchlist. Silakan coba lagi.',
      );
      notifyListeners();
    }
  }

  void setSearchQuery(String value) {
    if (_query == value) return;
    _query = value;
    _emitLoaded();
  }

  void clearSearch() {
    _query = '';
    _emitLoaded();
  }

  Future<void> incrementEpisode(String dramaId) async {
    Drama? target;
    for (final drama in _allDramas) {
      if (drama.id == dramaId) {
        target = drama;
        break;
      }
    }
    if (target == null || target.watchedEpisodes >= target.totalEpisodes) return;

    try {
      await _repository.updateWatchedEpisodes(
        dramaId,
        target.watchedEpisodes + 1,
      );
    } catch (_) {
      if (_isDisposed) return;
      _state = const WatchlistError(
        'Gagal memperbarui progres episode. Silakan coba lagi.',
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