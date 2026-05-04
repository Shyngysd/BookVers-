import 'package:bookvers/data/datasources/hive_local_datasource.dart';
import 'package:bookvers/data/repositories/book_repository_impl.dart';
import 'package:bookvers/domain/entities/book.dart';
import 'package:bookvers/domain/repositories/book_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider для локального datasource (Hive)
final localDataSourceProvider = Provider<ILocalDataSource>((ref) {
  return HiveLocalDataSource();
});

/// Provider для репозитория книг
final bookRepositoryProvider = Provider<IBookRepository>((ref) {
  final localDataSource = ref.watch(localDataSourceProvider);
  return HiveBookRepository(localDataSource);
});

/// Provider для получения всех книг
final allBooksProvider = FutureProvider((ref) async {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.getAllBooks();
});

/// Provider для получения книги по ID
final bookByIdProvider = FutureProvider.family<Book?, int>((ref, bookId) async {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.getBookById(bookId);
});

/// Provider для получения книг по жанру
final booksByGenreProvider =
    FutureProvider.family<List<Book>, int>((ref, genreId) async {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.getBooksByGenre(genreId);
});

/// Provider для поиска книг
final searchBooksProvider = FutureProvider.family<List<Book>, String>((ref, query) async {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.searchBooks(query);
});
