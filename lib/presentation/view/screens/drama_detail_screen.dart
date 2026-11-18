import 'package:flutter/material.dart';
import '../../../domain/entities/drama.dart';
import '../../viewmodels/drama_detail/drama_detail_state.dart';
import '../../viewmodels/drama_detail/drama_detail_view_model.dart';

class DramaDetailScreen extends StatefulWidget {
  final DramaDetailViewModel viewModel;

  const DramaDetailScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<DramaDetailScreen> createState() => _DramaDetailScreenState();
}

class _DramaDetailScreenState extends State<DramaDetailScreen> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  Future<void> _incrementEpisode(Drama drama) async {
    if (drama.watchedEpisodes < drama.totalEpisodes) {
      await widget.viewModel.incrementEpisode();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Progress updated: Episode ${widget.viewModel.currentDrama.watchedEpisodes}!',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final state = widget.viewModel.state;

        return switch (state) {
          DramaDetailError(:final message) => Scaffold(
            appBar: AppBar(title: const Text('Drama Detail')),
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(message, textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
          DramaDetailLoaded(:final drama) => Scaffold(
            appBar: AppBar(
              title: Text(drama.title),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 110,
                            height: 155,
                            color: theme.colorScheme.surfaceContainerHigh,
                            child: drama.imageUrl.isNotEmpty
                                ? Image.network(
                              drama.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Icon(
                                Icons.movie_outlined,
                                size: 48,
                                color: theme.colorScheme.primary,
                              ),
                            )
                                : Icon(
                              Icons.movie_outlined,
                              size: 48,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                drama.title,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Chip(
                                avatar: const Icon(Icons.star, size: 18),
                                label: Text('${drama.rating} / 10.0'),
                              ),
                              Text(
                                '${drama.origin} • ${drama.genre}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Tropes & Tags',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: drama.tags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          backgroundColor:
                          theme.colorScheme.secondaryContainer,
                          labelStyle: TextStyle(
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Synopsis',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      drama.synopsis.isNotEmpty
                          ? drama.synopsis
                          : 'No synopsis available for this drama.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),

                    Card(
                      color: theme.colorScheme.surfaceContainerLow,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Watch Progress Tracker',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: drama.totalEpisodes > 0
                                  ? drama.watchedEpisodes /
                                  drama.totalEpisodes
                                  : 0,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Watched: ${drama.watchedEpisodes} / ${drama.totalEpisodes} Eps',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                FilledButton.icon(
                                  onPressed: drama.watchedEpisodes < drama.totalEpisodes
                                      ? () => _incrementEpisode(drama)
                                      : null,
                                  icon: const Icon(Icons.add),
                                  label: const Text(
                                    'Tambah Episode',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        };
      },
    );
  }
}