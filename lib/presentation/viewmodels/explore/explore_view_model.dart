import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../domain/entities/drama.dart';
import '../../../domain/repositories/drama_repository.dart';
import 'explore_state.dart';

class ExploreViewModel extends ChangeNotifier {
  final DramaRepository _repository;
  StreamSubscription<List<Drama>>? _subscription;

  ExploreState _state = const ExploreInitial();
  List<Drama> _allDramas = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isDisposed = false;

  static const List<String> _categories = [
    'All',
    'K-Drama',
    'C-Drama',
    'Romance',
    'Fantasy',
    'Action',
  ];

  ExploreViewModel(this._repository) {
    _subscription = _repository.watchDramas().listen((dramas) {
      _allDramas = dramas;
      _emitLoaded();
    });
  }

  ExploreState get state => _state;

  List<Drama> get _filteredDramas {
    return _allDramas.where((drama) {
      final matchesCategory = _selectedCategory == 'All' ||
          drama.origin == _selectedCategory ||
          drama.genre.toLowerCase().contains(_selectedCategory.toLowerCase());
      final matchesSearch = _searchQuery.isEmpty ||
          drama.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _emitLoaded() {
    if (_isDisposed) return;
    _state = ExploreLoaded(
      dramas: _filteredDramas,
      selectedCategory: _selectedCategory,
      searchQuery: _searchQuery,
      categories: _categories,
    );
    notifyListeners();
  }

  Future<void> loadDramas() async {
    _state = const ExploreLoading();
    notifyListeners();

    try {
      _allDramas = await _repository.getDramas();
      if (_isDisposed) return;
      _emitLoaded();
    } catch (_) {
      if (_isDisposed) return;
      _state = const ExploreError(
        'Gagal memuat katalog drama. Silakan coba lagi.',
      );
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _emitLoaded();
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    _emitLoaded();
  }

  Future<void> toggleBookmark(String dramaId) async {
    try {
      await _repository.toggleBookmark(dramaId);
    } catch (_) {
      if (_isDisposed) return;
      _state = const ExploreError(
        'Gagal memperbarui status bookmark. Silakan coba lagi.',
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