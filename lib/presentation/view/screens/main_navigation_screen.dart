import 'package:flutter/material.dart';
import '../../../domain/entities/drama.dart';
import '../../viewmodels/explore/explore_view_model.dart';
import '../../viewmodels/watchlist/watchlist_view_model.dart';
import 'home_screen.dart';
import 'watchlist_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final ExploreViewModel exploreViewModel;
  final WatchlistViewModel watchlistViewModel;
  final Widget Function(Drama drama) buildDetailScreen;

  const MainNavigationScreen({
    super.key,
    required this.exploreViewModel,
    required this.watchlistViewModel,
    required this.buildDetailScreen,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        viewModel: widget.exploreViewModel,
        buildDetailScreen: widget.buildDetailScreen,
      ),
      WatchlistScreen(
        viewModel: widget.watchlistViewModel,
        buildDetailScreen: widget.buildDetailScreen,
        onAddDramaTap: () => setState(() => _currentIndex = 0),
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Watchlist',
          ),
        ],
      ),
    );
  }
}