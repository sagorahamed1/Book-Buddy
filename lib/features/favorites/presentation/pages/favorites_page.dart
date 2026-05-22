import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../books/domain/entities/book_entity.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_event.dart';
import '../bloc/favorites_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(title: const Text('My Favorites')),


      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {

          /// Handle Loading State

          if (state.status == FavoritesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          /// If favorites data empty

          if (state.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 72,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha:0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on any book to save it here.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha:0.5),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }


          /// If Data loaded show on ui

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final book = state.favorites[index];
              return _FavoriteBookTile(book: book);
            },
          );
        },
      ),
    );
  }
}

class _FavoriteBookTile extends StatelessWidget {
  final BookEntity book;
  const _FavoriteBookTile({required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        onTap: () => context.push('/book/${book.id}', extra: book),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: book.thumbnailUrl != null
              ? CachedNetworkImage(
                  imageUrl: book.thumbnailUrl!,
                  width: 44,
                  height: 60,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => _placeholder(theme),
                )
              : _placeholder(theme),
        ),
        title: Text(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          book.authorsDisplay,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () => context
              .read<FavoritesBloc>()
              .add(ToggleFavoriteEvent(book)),
          tooltip: 'Remove from favorites',
        ),
      ),
    );
  }

  Widget _placeholder(ThemeData theme) => Container(
        width: 44,
        height: 60,
        color: theme.colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.book_outlined,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
}
