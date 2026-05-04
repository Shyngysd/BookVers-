import 'package:bookvers/domain/entities/genre.dart';

class GenreModel {
  final int id;
  final String name;
  final String? description;

  GenreModel({
    required this.id,
    required this.name,
    this.description,
  });

  /// Конвертируем GenreModel в domain Genre
  Genre toDomain() {
    return Genre(
      id: id,
      name: name,
      description: description,
    );
  }

  /// Конвертируем domain Genre в GenreModel
  factory GenreModel.fromDomain(Genre genre) {
    return GenreModel(
      id: genre.id,
      name: genre.name,
      description: genre.description,
    );
  }
}
