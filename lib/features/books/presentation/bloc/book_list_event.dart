import 'package:equatable/equatable.dart';
import '../../../../core/constants/api_constants.dart';

abstract class BookListEvent extends Equatable {
  const BookListEvent();
}

class FetchBooksEvent extends BookListEvent {
  final String query;
  const FetchBooksEvent({this.query = ApiConstants.defaultQuery});

  @override
  List<Object> get props => [query];
}

class LoadMoreBooksEvent extends BookListEvent {
  const LoadMoreBooksEvent();

  @override
  List<Object> get props => [];
}

class RefreshBooksEvent extends BookListEvent {
  const RefreshBooksEvent();

  @override
  List<Object> get props => [];
}

class SearchBooksEvent extends BookListEvent {
  final String query;
  const SearchBooksEvent(this.query);

  @override
  List<Object> get props => [query];
}
