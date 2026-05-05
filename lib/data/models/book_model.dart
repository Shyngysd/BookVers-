import 'package:bookvers/domain/entities/book.dart';

class BookModel {
  final int id;
  final String title;
  final String author;
  final String description;
  final String status; // Сохраняем как строку для упрощения
  final int genreId;
  final String? url; // Опциональная ссылка на книгу

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.status,
    required this.genreId,
    this.url,
  });

  Book toDomain() {
    return Book(
      id: id,
      title: title,
      author: author,
      description: description,
      status: BookStatus.values.firstWhere(
        (e) => e.toString().split('.').last == status,
        orElse: () => BookStatus.available,
      ),
      genreId: genreId,
      url: url,
    );
  }

  /// Конвертируем domain Book в BookModel
  factory BookModel.fromDomain(Book book) {
    return BookModel(
      id: book.id,
      title: book.title,
      author: book.author,
      description: book.description,
      status: book.status.toString().split('.').last,
      genreId: book.genreId,
      url: book.url,
    );
  }
}
