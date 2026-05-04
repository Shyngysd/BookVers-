import 'package:bookvers/data/providers/book_providers.dart';
import 'package:bookvers/domain/entities/book.dart';
import 'package:bookvers/presentation/viewmodels/book_notifier.dart';
import 'package:bookvers/presentation/viewmodels/book_view_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider для BookNotifier с управлением состоянием
final bookNotifierProvider =
    StateNotifierProvider<BookNotifier, BookViewState>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return BookNotifier(repository);
});

/// Provider для просмотра отфильтрованного списка книг
final filteredBooksProvider = Provider<List<Book>>((ref) {
  final bookState = ref.watch(bookNotifierProvider);
  return bookState.filteredBooks;
});

/// Provider для проверки наличия активных фильтров
final hasActiveFiltersProvider = Provider<bool>((ref) {
  final bookState = ref.watch(bookNotifierProvider);
  return bookState.searchQuery.isNotEmpty || bookState.statusFilter != null;
});
