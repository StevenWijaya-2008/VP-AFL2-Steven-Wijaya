import 'package:flutter/material.dart';

class EmptyWatchlist extends StatelessWidget {
  final String query;
  final VoidCallback onClear;
  final VoidCallback? onAdd;

  const EmptyWatchlist({
    super.key,
    required this.query,
    required this.onClear,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSearching = query.trim().isNotEmpty;

    return Center(
      key: const Key('empty-state'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off_rounded : Icons.movie_filter_outlined,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              isSearching
                  ? 'No drama found for "$query"'
                  : 'Your watchlist is empty',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (isSearching)
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.close),
              label: const Text('Clear search'),
            )
          else
            FilledButton.icon(
              onPressed: onAdd ?? () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Drama'),
            ),
        ],
      ),
    );
  }
}