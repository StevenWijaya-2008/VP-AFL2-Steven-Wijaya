import 'package:flutter/material.dart';
import 'app.dart';
import 'data/repositories/drama_repository_impl.dart';
import 'data/services/drama_service.dart';
import 'domain/entities/drama.dart';
import 'domain/repositories/drama_repository.dart';
import 'presentation/viewmodels/drama_detail/drama_detail_view_model.dart';
import 'presentation/viewmodels/explore/explore_view_model.dart';
import 'presentation/viewmodels/watchlist/watchlist_view_model.dart';
import 'presentation/view/screens/drama_detail_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final DramaService dramaService = LocalDramaService();

  final DramaRepository dramaRepository = DramaRepositoryImpl(dramaService);

  final exploreViewModel = ExploreViewModel(dramaRepository);
  final watchlistViewModel = WatchlistViewModel(dramaRepository);

  await exploreViewModel.loadDramas();
  await watchlistViewModel.loadWatchlist();

  runApp(
    WarungApp(
      exploreViewModel: exploreViewModel,
      watchlistViewModel: watchlistViewModel,
      buildDetailScreen: (Drama drama) => DramaDetailScreen(
        viewModel : DramaDetailViewModel(
          repository: dramaRepository,
          initialDrama: drama,
        ),
      ),
    ),
  );
}