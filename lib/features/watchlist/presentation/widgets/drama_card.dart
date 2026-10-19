import 'package:flutter/material.dart';
import '../../domain/drama_model.dart';

class DramaCard extends StatelessWidget {
  final Drama drama;
  final VoidCallback onTap;
  final Widget? trailingAction;

  const DramaCard({
    super.key,
    required this.drama,
    required this.onTap,
    this.trailingAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 70,
                  height: 95,
                  color: theme.colorScheme.surfaceContainerHigh,
                  child: drama.imageUrl.isNotEmpty
                      ? Image.network(
                    drama.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.movie_outlined,
                      size: 32,
                      color: theme.colorScheme.primary,
                    ),
                  )
                      : Icon(
                    Icons.movie_outlined,
                    size: 32,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            drama.origin,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.star_rounded,
                            size: 16, color: Colors.amber.shade700),
                        const SizedBox(width: 2),
                        Text(
                          drama.rating.toString(),
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      drama.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${drama.genre} • Ep ${drama.watchedEpisodes}/${drama.totalEpisodes}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailingAction != null)
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  child: trailingAction!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}