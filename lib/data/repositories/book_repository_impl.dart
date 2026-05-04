import 'package:bookvers/data/datasources/hive_local_datasource.dart';
import 'package:bookvers/data/models/book_model.dart';
import 'package:bookvers/domain/entities/book.dart';
import 'package:bookvers/domain/repositories/book_repository.dart';

class HiveBookRepository implements IBookRepository {
  final ILocalDataSource _localDataSource;

  HiveBookRepository(this._localDataSource);

  @override
  Future<List<Book>> getAllBooks() async {
    final models = await _localDataSource.getAllBooks();
    return models.map((model) => model.toDomain()).toList();
  }

  @override
  Future<Book?> getBookById(int id) async {
    final model = await _localDataSource.getBookById(id);
    return model?.toDomain();
  }

  @override
  Future<List<Book>> getBooksByGenre(int genreId) async {
    final models = await _localDataSource.getBooksByGenre(genreId);
    return models.map((model) => model.toDomain()).toList();
  }

  @override
  Future<List<Book>> getBooksByStatus(BookStatus status) async {
    final models = await _localDataSource.getBooksByStatus(status);
    return models.map((model) => model.toDomain()).toList();
  }

  @override
  Future<void> createBook(Book book) async {
    final model = BookModel.fromDomain(book);
    await _localDataSource.saveBook(model);
  }

  @override
  Future<void> updateBook(Book book) async {
    final model = BookModel.fromDomain(book);
    await _localDataSource.updateBook(model);
  }

  @override
  Future<void> deleteBook(int id) async {
    await _localDataSource.deleteBook(id);
  }

  @override
  Future<void> deleteAllBooks() async {
    await _localDataSource.deleteAllBooks();
  }

  @override
  Future<void> updateBookStatus(int bookId, BookStatus newStatus) async {
    final book = await getBookById(bookId);
    if (book != null) {
      final updatedBook = book.copyWith(status: newStatus);
      await updateBook(updatedBook);
    }
  }

  @override
  Future<List<Book>> searchBooks(String query) async {
    final models = await _localDataSource.searchBooks(query);
    return models.map((model) => model.toDomain()).toList();
  }
}
