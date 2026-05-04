import 'package:bookvers/domain/entities/book.dart';

abstract class IBookRepository {
  /// Получить все книги
  Future<List<Book>> getAllBooks();

  /// Получить книгу по ID
  Future<Book?> getBookById(int id);

  /// Получить книги по жанру
  Future<List<Book>> getBooksByGenre(int genreId);

  /// Получить книги по статусу
  Future<List<Book>> getBooksByStatus(BookStatus status);

  /// Добавить новую книгу
  Future<void> createBook(Book book);

  /// Обновить книгу
  Future<void> updateBook(Book book);

  /// Удалить книгу по ID
  Future<void> deleteBook(int id);

  /// Удалить все книги
  Future<void> deleteAllBooks();

  /// Изменить статус книги
  Future<void> updateBookStatus(int bookId, BookStatus newStatus);

  /// Поиск книг по названию или автору
  Future<List<Book>> searchBooks(String query);
}
