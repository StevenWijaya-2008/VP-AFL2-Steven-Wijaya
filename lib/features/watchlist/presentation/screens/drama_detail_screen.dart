import 'package:flutter/material.dart';
import '../../domain/drama_model.dart';

class DramaDetailScreen extends StatefulWidget {
  final Drama drama;

  const DramaDetailScreen({
    super.key,
    required this.drama,
  });

  @override
  State<DramaDetailScreen> createState() => _DramaDetailScreenState();
}

class _DramaDetailScreenState extends State<DramaDetailScreen> {
  late int _watchedEpisodes;

  @override
  void initState() {
    super.initState();
    _watchedEpisodes = widget.drama.watchedEpisodes;
  }

  void _incrementEpisode() {
    if (_watchedEpisodes < widget.drama.totalEpisodes) {
      setState(() => _watchedEpisodes++);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Progress updated: Episode $_watchedEpisodes!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final drama = widget.drama;

    return Scaffold(
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
                          label: Text('${drama.rating} / 5.0'),
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
                    backgroundColor: theme.colorScheme.secondaryContainer,
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
                            ? _watchedEpisodes / drama.totalEpisodes
                            : 0,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Watched: $_watchedEpisodes / ${drama.totalEpisodes} Eps',
                            style: theme.textTheme.bodyMedium,
                          ),
                          FilledButton.icon(
                            onPressed: _watchedEpisodes < drama.totalEpisodes
                                ? _incrementEpisode
                                : null,
                            icon: const Icon(Icons.add),
                            label: const Text('Tambah Episode'),
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
    );
  }
}