import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'domain/entities/drama.dart';
import 'presentation/viewmodels/explore/explore_view_model.dart';
import 'presentation/viewmodels/watchlist/watchlist_view_model.dart';
import 'presentation/view/screens/main_navigation_screen.dart';

class WarungApp extends StatelessWidget {
  final ExploreViewModel exploreViewModel;
  final WatchlistViewModel watchlistViewModel;
  final Widget Function(Drama drama) buildDetailScreen;

  const WarungApp({
    super.key,
    required this.exploreViewModel,
    required this.watchlistViewModel,
    required this.buildDetailScreen,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drama Vault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: MainNavigationScreen(
        exploreViewModel: exploreViewModel,
        watchlistViewModel: watchlistViewModel,
        buildDetailScreen: buildDetailScreen,
      ),
    );
  }
}