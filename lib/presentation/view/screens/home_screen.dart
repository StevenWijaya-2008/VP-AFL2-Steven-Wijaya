import 'package:flutter/material.dart';
import '../../../domain/entities/drama.dart';
import '../../viewmodels/explore/explore_state.dart';
import '../../viewmodels/explore/explore_view_model.dart';
import '../widgets/home_header.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/responsive_drama_view.dart';

class HomeScreen extends StatelessWidget {
  final ExploreViewModel viewModel;
  final Widget Function(Drama drama) buildDetailScreen;

  const HomeScreen({
    super.key,
    required this.viewModel,
    required this.buildDetailScreen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final state = viewModel.state;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Drama Vault'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: viewModel.loadDramas,
              ),
            ],
          ),
          body: SafeArea(
            child: switch (state) {
              ExploreInitial() || ExploreLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              ExploreError(:final message) => Center(
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
                        onPressed: viewModel.loadDramas,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
              ExploreLoaded(
                  :final dramas,
                  :final selectedCategory,
                  :final categories,
              ) =>
                  CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const HomeHeader(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: SearchBar(
                                hintText: 'Search catalog...',
                                leading: const Icon(Icons.search),
                                elevation: WidgetStateProperty.all(0),
                                backgroundColor: WidgetStateProperty.all(
                                  theme.colorScheme.surfaceContainerHigh,
                                ),
                                onChanged: viewModel.setSearchQuery,
                              ),
                            ),
                            CategoryFilterChips(
                              categories: categories,
                              selectedCategory: selectedCategory,
                              onSelected: viewModel.selectCategory,
                            ),
                          ],
                        ),
                      ),
                      if (dramas.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              'No dramas found.',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ),
                        )
                      else
                        ResponsiveDramaView(
                          dramas: dramas,
                          onToggleBookmark: viewModel.toggleBookmark,
                          onDramaTap: (drama) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => buildDetailScreen(drama)
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
}