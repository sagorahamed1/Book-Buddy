import 'dart:async';
import 'package:bookbuddy/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/book_list_bloc.dart';
import '../bloc/book_list_event.dart';
import '../bloc/book_list_state.dart';
import '../widgets/book_card.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_display_widget.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _debounce;
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    context.read<BookListBloc>().add(const FetchBooksEvent());
    _scrollController.addListener(_onScroll);
  }


  /// Disposes all controllers, stream subscription and listeners to free up memory.

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      final state = context.read<BookListBloc>().state;
      if (state is BookListLoaded &&
          !state.hasReachedMax &&
          !state.isLoadingMore) {
        context.read<BookListBloc>().add(const LoadMoreBooksEvent());
      }
    }
  }


  /// Delays the API call until the user stops typing for 500ms.
  /// Cancels the previous timer on each keystroke to avoid unnecessary requests.

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<BookListBloc>().add(SearchBooksEvent(query));
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _showSearch = false);
    context.read<BookListBloc>().add(const FetchBooksEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(

      /// App Bar

      appBar: AppBar(
        title: _showSearch
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search books...',
                  filled: false,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: _onSearchChanged,
              )
            : Text('BookBuddy',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          if (_showSearch)

            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _clearSearch,
            )

          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => setState(() => _showSearch = true),
            ),

          IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () => context.push(AppRouter.favorites),
          ),
        ],
      ),


      /// Body

      body: BlocBuilder<BookListBloc, BookListState>(
        builder: (context, state) {

          /// Handle Loading State

          if (state is BookListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          /// If Throws Error

          if (state is BookListError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () =>
                  context.read<BookListBloc>().add(const RefreshBooksEvent()),
            );
          }


          /// If Data loaded show on ui

          if (state is BookListLoaded) {
            if (state.books.isEmpty) {
              return EmptyStateWidget(
                title: 'No books found',
                subtitle: 'Try a different search term.',
                icon: Icons.menu_book_outlined,
                onAction: _clearSearch,
                actionLabel: 'Clear Search',
              );
            }


            /// Scroll up to bottom page will be refresh call api for fetch data

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<BookListBloc>()
                    .add(const RefreshBooksEvent());
                await context
                    .read<BookListBloc>()
                    .stream
                    .firstWhere((s) => s is! BookListLoading);
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                itemCount:
                    state.books.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.books.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final book = state.books[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: BookCard(
                      book: book,
                      onTap: () =>
                          context.push('/book/${book.id}', extra: book),
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
