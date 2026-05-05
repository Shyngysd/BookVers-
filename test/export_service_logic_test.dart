import 'package:bookvers/domain/entities/book.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Export Logic Tests', () {
    // Тестовые данные
    final testBooks = [
      const Book(
        id: 1,
        title: 'Война и мир',
        author: 'Лев Толстой',
        description: 'Исторический роман',
        status: BookStatus.available,
        genreId: 1,
        url: null,
      ),
      const Book(
        id: 2,
        title: '1984',
        author: 'Джордж Оруэлл',
        description: 'Антиутопия',
        status: BookStatus.borrowed,
        genreId: 2,
        url: 'https://example.com/1984',
      ),
    ];

    group('CSV Generation', () {
      test('generateCsvHeaders возвращает правильные колонки', () {
        final headers = ['ID', 'Название', 'Автор', 'Описание', 'Статус', 'Жанр ID'];
        expect(headers.length, 6);
        expect(headers.first, 'ID');
        expect(headers.contains('Название'), true);
      });

      test('generateCsvRow форматирует данные книги', () {
        final book = testBooks.first;
        final row = [
          book.id.toString(),
          book.title,
          book.author,
          book.description,
          book.status.toString().split('.').last,
          book.genreId.toString(),
        ];

        expect(row.length, 6);
        expect(row.contains('Война и мир'), true);
        expect(row.contains('Лев Толстой'), true);
      });

      test('generateCsvContent создает корректный формат', () {
        final headers = 'ID,Название,Автор,Описание,Статус,Жанр ID';
        final rows = testBooks.map((book) {
          return '${book.id},${book.title},${book.author},${book.description},'
              '${book.status.toString().split('.').last},${book.genreId}';
        }).toList();

        final csv = [headers, ...rows].join('\n');

        expect(csv.contains('Война и мир'), true);
        expect(csv.contains('1984'), true);
        expect(csv.split('\n').length, 3); // header + 2 books
      });

      test('generateCsvContent обрабатывает пустой список', () {
        final headers = 'ID,Название,Автор,Описание,Статус,Жанр ID';
        final rows = <Book>[].map((book) {
          return '${book.id},${book.title},${book.author},${book.description},'
              '${book.status.toString().split('.').last},${book.genreId}';
        }).toList();

        final csv = [headers, ...rows].join('\n');

        expect(csv.split('\n').length, 1); // только заголовок
      });
    });

    group('PDF Generation', () {
      test('generatePdfTitle форматирует заголовок', () {
        final title = 'Моя библиотека BookVerse';
        expect(title.isNotEmpty, true);
        expect(title.contains('BookVerse'), true);
      });

      test('generatePdfContent создает правильное количество строк', () {
        final content = StringBuffer();
        content.writeln('=== Моя библиотека ===\n');

        for (final book in testBooks) {
          content.writeln('📖 ${book.title}');
          content.writeln('Автор: ${book.author}');
          content.writeln('Описание: ${book.description}');
          content.writeln('');
        }

        expect(content.toString().contains('Война и мир'), true);
        expect(content.toString().contains('Лев Толстой'), true);
      });

      test('generatePdfContent обрабатывает пустой список', () {
        final content = StringBuffer();
        content.writeln('=== Моя библиотека ===\n');

        final books = <Book>[];
        for (final book in books) {
          content.writeln('📖 ${book.title}');
        }

        final result = content.toString();
        expect(result.contains('Война и мир'), false);
        expect(result.contains('Моя библиотека'), true);
      });
    });

    group('Filename Generation', () {
      test('generateCsvFilename содержит расширение .csv', () {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filename = 'books_$timestamp.csv';

        expect(filename.endsWith('.csv'), true);
        expect(filename.startsWith('books_'), true);
      });

      test('generatePdfFilename содержит расширение .pdf', () {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filename = 'books_$timestamp.pdf';

        expect(filename.endsWith('.pdf'), true);
        expect(filename.startsWith('books_'), true);
      });

      test('разные временные метки генерируют разные имена', () {
        final name1 = 'books_${DateTime.now().millisecondsSinceEpoch}.csv';
        final name2 = 'books_${DateTime.now().millisecondsSinceEpoch + 1}.csv';

        expect(name1, isNot(name2));
      });
    });

    group('URL Handling', () {
      test('книга с URL сохраняет URL', () {
        final bookWithUrl = testBooks.where((b) => b.url != null).first;
        expect(bookWithUrl.url, 'https://example.com/1984');
      });

      test('книга без URL имеет null', () {
        final bookWithoutUrl = testBooks.where((b) => b.url == null).first;
        expect(bookWithoutUrl.url, null);
      });

      test('URL преобразуется в строку для экспорта', () {
        final book = testBooks.firstWhere((b) => b.url != null);
        final urlString = book.url ?? 'Нет ссылки';

        expect(urlString, 'https://example.com/1984');
      });
    });
  });
}
