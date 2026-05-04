import 'package:bookvers/data/models/book_model.dart';
import 'package:bookvers/domain/entities/book.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class ILocalDataSource {
  /// Получить все книги
  Future<List<BookModel>> getAllBooks();

  /// Получить книгу по ID
  Future<BookModel?> getBookById(int id);

  /// Сохранить книгу
  Future<void> saveBook(BookModel book);

  /// Обновить книгу
  Future<void> updateBook(BookModel book);

  /// Удалить книгу
  Future<void> deleteBook(int id);

  /// Удалить все книги
  Future<void> deleteAllBooks();

  /// Получить книги по жанру
  Future<List<BookModel>> getBooksByGenre(int genreId);

  /// Получить книги по статусу
  Future<List<BookModel>> getBooksByStatus(BookStatus status);

  /// Поиск книг
  Future<List<BookModel>> searchBooks(String query);
}

class HiveLocalDataSource implements ILocalDataSource {
  static const String boxName = 'books';

  Future<Box<BookModel>> get _booksBox => Hive.openBox<BookModel>(boxName);

  @override
  Future<List<BookModel>> getAllBooks() async {
    final box = await _booksBox;
    return box.values.toList();
  }

  @override
  Future<BookModel?> getBookById(int id) async {
    final box = await _booksBox;
    try {
      return box.values.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveBook(BookModel book) async {
    final box = await _booksBox;
    await box.put(book.id, book);
  }

  @override
  Future<void> updateBook(BookModel book) async {
    final box = await _booksBox;
    if (box.containsKey(book.id)) {
      await box.put(book.id, book);
    }
  }

  @override
  Future<void> deleteBook(int id) async {
    final box = await _booksBox;
    await box.delete(id);
  }

  @override
  Future<void> deleteAllBooks() async {
    final box = await _booksBox;
    await box.clear();
  }

  @override
  Future<List<BookModel>> getBooksByGenre(int genreId) async {
    final box = await _booksBox;
    final books = box.values.where((book) => book.genreId == genreId).toList();
    return books;
  }

  @override
  Future<List<BookModel>> getBooksByStatus(BookStatus status) async {
    final box = await _booksBox;
    final statusStr = status.toString().split('.').last;
    final books = box.values.where((book) => book.status == statusStr).toList();
    return books;
  }

  @override
  Future<List<BookModel>> searchBooks(String query) async {
    final box = await _booksBox;
    final lowerQuery = query.toLowerCase();
    final books = box.values
        .where((book) =>
            book.title.toLowerCase().contains(lowerQuery) ||
            book.author.toLowerCase().contains(lowerQuery))
        .toList();
    return books;
  }
}
