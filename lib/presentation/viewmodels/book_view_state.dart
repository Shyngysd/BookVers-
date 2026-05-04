import 'package:bookvers/domain/entities/book.dart';

class BookViewState {
  final List<Book> books;
  final String searchQuery;
  final BookStatus? statusFilter;

  BookViewState({
    required this.books,
    this.searchQuery = '',
    this.statusFilter,
  });

  BookViewState copyWith({
    List<Book>? books,
    String? searchQuery,
    BookStatus? statusFilter,
  }) {
    return BookViewState(
      books: books ?? this.books,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }

  /// Получить отфильтрованные книги с учётом поиска и фильтра по статусу
  List<Book> get filteredBooks {
    var result = books;

    // Фильтруем по статусу
    if (statusFilter != null) {
      result = result.where((book) => book.status == statusFilter).toList();
    }

    // Фильтруем по поиску
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result
          .where((book) =>
              book.title.toLowerCase().contains(query) ||
              book.author.toLowerCase().contains(query))
          .toList();
    }

    return result;
  }
}
