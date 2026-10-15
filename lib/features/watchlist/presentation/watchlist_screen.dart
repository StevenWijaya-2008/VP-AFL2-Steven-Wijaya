import 'package:flutter/material.dart';
import '../domain/drama_model.dart';
import 'widgets/watchlist_header.dart';
import 'widgets/watchlist_search.dart';
import 'widgets/drama_card.dart';
import 'widgets/empty_watchlist.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final List<Drama> _dramas = const [
    Drama(id: 'd1', title: 'Crash Landing on You', genre: 'Romance', totalEpisodes: 16, watchedEpisodes: 16),
    Drama(id: 'd2', title: 'Alchemy of Souls', genre: 'Fantasy', totalEpisodes: 30, watchedEpisodes: 12),
    Drama(id: 'd3', title: 'Vincenzo', genre: 'Action', totalEpisodes: 20, watchedEpisodes: 5),
  ];

  late TextEditingController _searchController;
  String _query = '';

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
    setState(() => _query = '');
  }

  void _incrementEpisode(String id) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Episode ditambahkan!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleDramas = _dramas.where((drama) =>
    _query.isEmpty || drama.title.toLowerCase().contains(_query.toLowerCase())
    ).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Drama Vault')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;

            return CustomScrollView(
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
                else if (isTablet)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 3.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final drama = visibleDramas[index];
                          return DramaCard(
                            drama: drama,
                            onAddEpisode: () => _incrementEpisode(drama.id),
                          );
                        },
                        childCount: visibleDramas.length,
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final drama = visibleDramas[index];
                          return DramaCard(
                            drama: drama,
                            onAddEpisode: () => _incrementEpisode(drama.id),
                          );
                        },
                        childCount: visibleDramas.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}