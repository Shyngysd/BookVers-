import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';

enum BookStatus {
  available,
  borrowed,
  reserved,
  unavailable,
}

@freezed
class Book with _$Book {
  const factory Book({
    required int id,
    required String title,
    required String author,
    required String description,
    required BookStatus status,
    required int genreId,
    String? url,
  }) = _Book;
}
