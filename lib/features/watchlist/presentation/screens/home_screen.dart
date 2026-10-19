import 'package:flutter/material.dart';
import '../../domain/drama_model.dart';
import '../../../../data/dummy_data.dart';
import '../widgets/home_header.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/responsive_drama_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  List<Drama> _dramas = dummyDramas;

  final List<String> _categories = const [
    'All', 'K-Drama', 'C-Drama', 'Romance', 'Fantasy', 'Action'
  ];

  void _toggleBookmark(String id) {
    setState(() {
      _dramas = _dramas.map((drama) {
        if (drama.id == id) {
          return drama.copyWith(isBookmarked: !drama.isBookmarked);
        }
        return drama;
      }).toList();
    });
  }

  void _refresh() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredDramas = _dramas.where((drama) {
      final matchesCategory = _selectedCategory == 'All' ||
          drama.origin == _selectedCategory || drama.genre == _selectedCategory;
      final matchesSearch = drama.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drama Vault'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh)
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const HomeHeader(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: SearchBar(
                      hintText: 'Search catalog...',
                      leading: const Icon(Icons.search),
                      elevation: WidgetStateProperty.all(0),
                      backgroundColor: WidgetStateProperty.all(
                        theme.colorScheme.surfaceContainerHigh,
                      ),
                      onChanged: (val) => setState(() => _searchQuery = val),
                    ),
                  ),
                  CategoryFilterChips(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onSelected: (cat) => setState(() => _selectedCategory = cat),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (filteredDramas.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'No dramas found.',
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.outline),
                  ),
                ),
              )
            else
              ResponsiveDramaView(
                dramas: filteredDramas,
                onToggleBookmark: _toggleBookmark,
              ),
          ],
        ),
      ),
    );
  }
}