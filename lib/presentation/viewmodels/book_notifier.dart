import 'package:bookvers/domain/entities/book.dart';
import 'package:bookvers/domain/repositories/book_repository.dart';
import 'package:bookvers/presentation/viewmodels/book_view_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

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

  /// Открыть ссылку на книгу в браузере
  Future<bool> openBookUrl(String? url) async {
    if (url == null || url.isEmpty) {
      debugPrint('[BookNotifier] URL пуст');
      return false;
    }

    try {
      // Нормализуем URL: добавляем https:// если не начинается с http
      String normalizedUrl = url.trim();
      if (!normalizedUrl.startsWith('http://') &&
          !normalizedUrl.startsWith('https://')) {
        normalizedUrl = 'https://$normalizedUrl';
        debugPrint('[BookNotifier] Добавлен https:// к URL: $normalizedUrl');
      }

      // Парсим URL
      final uri = Uri.tryParse(normalizedUrl);
      if (uri == null) {
        debugPrint('[BookNotifier] ❌ Ошибка парсинга URL: $normalizedUrl');
        return false;
      }

      debugPrint('[BookNotifier] 🔗 Попытка открыть URL: $normalizedUrl');

      // Проверяем, может ли система открыть URL
      if (await canLaunchUrl(uri)) {
        debugPrint('[BookNotifier] ✅ Система может открыть URL');
        final result = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        debugPrint('[BookNotifier] 📱 Результат запуска: $result');
        return result;
      } else {
        debugPrint('[BookNotifier] ❌ Система не может открыть URL');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('[BookNotifier] ❌ Ошибка при открытии URL: $e');
      debugPrint('[BookNotifier] Stack trace: $stackTrace');
      return false;
    }
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
