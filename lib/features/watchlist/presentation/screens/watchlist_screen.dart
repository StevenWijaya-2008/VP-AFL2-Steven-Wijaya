import 'package:flutter/material.dart';
import '../../../../data/dummy_data.dart';
import '../../domain/drama_model.dart';
import '../widgets/drama_card.dart';
import '../widgets/empty_watchlist.dart';
import '../widgets/watchlist_header.dart';
import '../widgets/watchlist_search.dart';
import 'drama_detail_screen.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  late List<Drama> _dramas;
  late TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _dramas = List.from(dummyDramas);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  void _incrementEpisode(String id) {
    setState(() {
      _dramas = _dramas.map((drama) {
        if (drama.id == id && drama.watchedEpisodes < drama.totalEpisodes) {
          final updatedWatched = drama.watchedEpisodes + 1;
          return drama.copyWith(watchedEpisodes: updatedWatched);
        }
        return drama;
      }).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Progress episode berhasil diperbarui!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _navigateToDetail(Drama drama) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DramaDetailScreen(drama: drama),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleDramas = _dramas
        .where((drama) =>
    _query.isEmpty ||
        drama.title.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Drama Vault')),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const WatchlistHeader(),
                  WatchlistSearch(
                    controller: _searchController,
                    query: _query,
                    onChanged: (value) => setState(() => _query = value),
                    onClear: _clearSearch,
                  ),
                ],
              ),
            ),
            if (visibleDramas.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyWatchlist(
                  query: _query,
                  onClear: _clearSearch,
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
                            visibleDramas[index], theme),
                        childCount: visibleDramas.length,
                      ),
                    )
                        : SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _buildDramaItem(
                              visibleDramas[index], theme),
                        ),
                        childCount: visibleDramas.length,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDramaItem(Drama drama, ThemeData theme) {
    return DramaCard(
      drama: drama,
      onTap: () => _navigateToDetail(drama),
      trailingAction: IconButton(
        icon: const Icon(Icons.add_circle_outline),
        tooltip: 'Tambah 1 Episode',
        onPressed: () => _incrementEpisode(drama.id),
      ),
    );
  }
}