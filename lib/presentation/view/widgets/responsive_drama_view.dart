import 'package:flutter/material.dart';
import '../../../domain/entities/drama.dart';
import 'drama_card.dart';

class ResponsiveDramaView extends StatelessWidget {
  final List<Drama> dramas;
  final ValueChanged<String> onToggleBookmark;
  final ValueChanged<Drama> onDramaTap;

  const ResponsiveDramaView({
    super.key,
    required this.dramas,
    required this.onToggleBookmark,
    required this.onDramaTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.crossAxisExtent >= 600;

        return SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: isTablet
              ? SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.8,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildCard(context, dramas[index], theme),
              childCount: dramas.length,
            ),
          )
              : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildCard(context, dramas[index], theme),
              ),
              childCount: dramas.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, Drama drama, ThemeData theme) {
    return DramaCard(
      drama: drama,
      onTap: () => onDramaTap(drama),
      trailingAction: IconButton(
        icon: Icon(
          drama.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
          color: drama.isBookmarked ? theme.colorScheme.primary : null,
        ),
        onPressed: () => onToggleBookmark(drama.id),
      ),
    );
  }
}