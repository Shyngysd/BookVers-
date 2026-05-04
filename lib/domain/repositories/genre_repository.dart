import 'package:bookvers/domain/entities/genre.dart';

abstract class IGenreRepository {
  /// Получить все жанры
  Future<List<Genre>> getAllGenres();

  /// Получить жанр по ID
  Future<Genre?> getGenreById(int id);

  /// Добавить новый жанр
  Future<void> createGenre(Genre genre);

  /// Обновить жанр
  Future<void> updateGenre(Genre genre);

  /// Удалить жанр по ID
  Future<void> deleteGenre(int id);
}
