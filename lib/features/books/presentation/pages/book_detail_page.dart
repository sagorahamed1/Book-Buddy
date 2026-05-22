import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_event.dart';
import '../../../favorites/presentation/bloc/favorites_state.dart';
import '../../domain/entities/book_entity.dart';

class BookDetailPage extends StatelessWidget {
  final BookEntity book;
  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(


      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _HeroBookCover(book: book),
            ),
            actions: [
              BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, state) {
                  final isFav = state.isFavorite(book.id);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_outline,
                      color: isFav ? Colors.red : null,
                    ),
                    onPressed: () => context
                        .read<FavoritesBloc>()
                        .add(ToggleFavoriteEvent(book)),
                    tooltip: isFav ? 'Remove from favorites' : 'Add to favorites',
                  );
                },
              ),
            ],
          ),



          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  book.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  book.authorsDisplay,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'First Published',
                  value: book.publishedYear,
                ),
                if (book.publisher != null)
                  _InfoRow(
                    icon: Icons.business_outlined,
                    label: 'Publisher',
                    value: book.publisher!,
                  ),
                if (book.pageCount != null)
                  _InfoRow(
                    icon: Icons.pages_outlined,
                    label: 'Pages',
                    value: book.pageCount!.toString(),
                  ),
                if (book.description != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    'About this book',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      color: theme.colorScheme.onSurface.withValues(alpha:0.85),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBookCover extends StatelessWidget {
  final BookEntity book;
  const _HeroBookCover({required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Stack(
        fit: StackFit.expand,
        children: [

          /// Check book thumbnailUrl not null
          /// I use Cached Network Image for caching. Avoids re-downloading the same image on every rebuild.

          if (book.thumbnailUrl != null)
            CachedNetworkImage(
              imageUrl: book.thumbnailUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const _CoverPlaceholder(),
            )
          else
            const _CoverPlaceholder(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha:0.5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Icon(
        Icons.menu_book_outlined,
        size: 80,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha:0.4),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
