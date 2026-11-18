import 'package:flutter/material.dart';
import '../../../domain/entities/drama.dart';
import '../../viewmodels/watchlist/watchlist_state.dart';
import '../../viewmodels/watchlist/watchlist_view_model.dart';
import '../widgets/drama_card.dart';
import '../widgets/empty_watchlist.dart';
import '../widgets/watchlist_header.dart';
import '../widgets/watchlist_search.dart';

class WatchlistScreen extends StatefulWidget {
  final WatchlistViewModel viewModel;
  final Widget Function(Drama drama) buildDetailScreen;
  final VoidCallback? onAddDramaTap;

  const WatchlistScreen({
    super.key,
    required this.viewModel,
    required this.buildDetailScreen,
    this.onAddDramaTap,
  });

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    widget.viewModel.clearSearch();
  }

  Future<void> _incrementEpisode(Drama drama) async {
    if (drama.watchedEpisodes < drama.totalEpisodes) {
      await widget.viewModel.incrementEpisode(drama.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Progress episode berhasil diperbarui!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _navigateToDetail(Drama drama) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => widget.buildDetailScreen(drama),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final state = widget.viewModel.state;

        return Scaffold(
          appBar: AppBar(title: const Text('Drama Vault')),
          body: SafeArea(
            child: switch (state) {
              WatchlistInitial() || WatchlistLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              WatchlistError(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: widget.viewModel.loadWatchlist,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
              WatchlistLoaded(:final visibleDramas, :final query) =>
                  CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const WatchlistHeader(),
                            WatchlistSearch(
                              controller: _searchController,
                              query: query,
                              onChanged: widget.viewModel.setSearchQuery,
                              onClear: _clearSearch,
                            ),
                          ],
                        ),
                      ),
                      if (visibleDramas.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: EmptyWatchlist(
                            query: query,
                            onClear: _clearSearch,
                            onAdd: widget.onAddDramaTap,
                          ),
                        )
                      else
                        SliverLayoutBuilder(
                          builder: (context, constraints) {
                            final isTablet = constraints.crossAxisExtent >= 600;

                            return SliverPadding(
                              padding: const EdgeInsets.all(16),
                              sliver: isTablet
                                  ? SliverGrid(
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 2.8,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                      (context, index) => _buildDramaItem(
                                    visibleDramas[index],
                                    theme,
                                  ),
                                  childCount: visibleDramas.length,
                                ),
                              )
                                  : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                      (context, index) => Padding(
                                    padding:
                                    const EdgeInsets.only(bottom: 8.0),
                                    child: _buildDramaItem(
                                      visibleDramas[index],
                                      theme,
                                    ),
                                  ),
                                  childCount: visibleDramas.length,
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
            },
          ),
        );
      },
    );
  }

  Widget _buildDramaItem(Drama drama, ThemeData theme) {
    return DramaCard(
      drama: drama,
      onTap: () => _navigateToDetail(drama),
      trailingAction: IconButton(
        icon: const Icon(Icons.add_circle_outline),
        tooltip: 'Tambah 1 Episode',
        onPressed: () => _incrementEpisode(drama),
      ),
    );
  }
}