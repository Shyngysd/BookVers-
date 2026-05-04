import 'package:bookvers/domain/entities/book.dart';
import 'package:bookvers/domain/repositories/book_repository.dart';
import 'package:bookvers/presentation/viewmodels/book_view_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookNotifier extends StateNotifier<BookViewState> {
  final IBookRepository _repository;

  BookNotifier(this._repository) : super(BookViewState(books: []));

  /// Инициализировать с загрузкой всех книг
  Future<void> initialize() async {
    try {
      final books = await _repository.getAllBooks();
      state = state.copyWith(books: books);
    } catch (e) {
      // Handle error if needed
      rethrow;
    }
  }

  /// Добавить новую книгу
  Future<void> addBook(Book book) async {
    await _repository.createBook(book);
    await _refresh();
  }

  /// Обновить книгу
  Future<void> updateBook(Book book) async {
    await _repository.updateBook(book);
    await _refresh();
  }

  /// Удалить книгу
  Future<void> deleteBook(int bookId) async {
    await _repository.deleteBook(bookId);
    await _refresh();
  }

  /// Изменить статус книги
  Future<void> updateBookStatus(int bookId, BookStatus newStatus) async {
    await _repository.updateBookStatus(bookId, newStatus);
    await _refresh();
  }

  /// Установить фильтр по статусу
  void setStatusFilter(BookStatus? status) {
    state = state.copyWith(statusFilter: status);
  }

  /// Установить поисковый запрос
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Очистить фильтры
  void clearFilters() {
    state = state.copyWith(searchQuery: '', statusFilter: null);
  }

  /// Обновить список книг
  Future<void> _refresh() async {
    try {
      final books = await _repository.getAllBooks();
      state = state.copyWith(books: books);
    } catch (e) {
      rethrow;
    }
  }
}
