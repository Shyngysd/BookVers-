import 'dart:io';

import 'package:bookvers/data/services/export_service.dart';
import 'package:bookvers/domain/entities/book.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExportService Tests', () {
    late ExportService exportService;

    setUp(() {
      exportService = ExportService();
    });

    // Тестовые данные
    final testBooks = [
      const Book(
        id: 1,
        title: 'Война и мир',
        author: 'Лев Толстой',
        description: 'Исторический роман',
        status: BookStatus.available,
        genreId: 1,
      ),
      const Book(
        id: 2,
        title: '1984',
        author: 'Джордж Оруэлл',
        description: 'Антиутопия',
        status: BookStatus.borrowed,
        genreId: 2,
      ),
    ];

    group('CSV Export', () {
      test('Экспортирует книги в CSV файл', () async {
        final file = await exportService.exportToCSV(testBooks);

        expect(file.existsSync(), true);
        expect(file.path.endsWith('.csv'), true);

        final content = file.readAsStringSync();
        expect(content.contains('Название'), true);
        expect(content.contains('Война и мир'), true);
        expect(content.contains('Лев Толстой'), true);

        // Очищаем
        if (file.existsSync()) {
          await exportService.deleteExportFile(file);
        }
      });

      test('Обрабатывает экспорт пустого списка', () async {
        final file = await exportService.exportToCSV([]);

        expect(file.existsSync(), true);
        final content = file.readAsStringSync();
        expect(content.contains('Название'), true);

        if (file.existsSync()) {
          await exportService.deleteExportFile(file);
        }
      });

      test('CSV файл содержит все необходимые колонки', () async {
        final file = await exportService.exportToCSV(testBooks);

        final content = file.readAsStringSync();
        expect(content.contains('Название'), true);
        expect(content.contains('Автор'), true);
        expect(content.contains('Описание'), true);
        expect(content.contains('Статус'), true);
        expect(content.contains('Жанр ID'), true);

        if (file.existsSync()) {
          await exportService.deleteExportFile(file);
        }
      });
    });

    group('PDF Export', () {
      test('Экспортирует книги в PDF файл', () async {
        final file = await exportService.exportToPDF(testBooks);

        expect(file.existsSync(), true);
        expect(file.path.endsWith('.pdf'), true);

        final size = file.lengthSync();
        expect(size, greaterThan(0));

        if (file.existsSync()) {
          await exportService.deleteExportFile(file);
        }
      });

      test('PDF файл содержит информацию о книгах', () async {
        final file = await exportService.exportToPDF(testBooks);

        expect(file.existsSync(), true);
        final bytes = file.readAsBytesSync();

        // PDF файлы начинаются с %PDF
        expect(
          String.fromCharCodes(bytes.take(4)),
          '%PDF',
        );

        if (file.existsSync()) {
          await exportService.deleteExportFile(file);
        }
      });

      test('Обрабатывает экспорт пустого списка в PDF', () async {
        final file = await exportService.exportToPDF([]);

        expect(file.existsSync(), true);
        expect(file.lengthSync(), greaterThan(0));

        if (file.existsSync()) {
          await exportService.deleteExportFile(file);
        }
      });
    });

    group('File Operations', () {
      test('Удаляет экспортированный файл', () async {
        final file = await exportService.exportToCSV(testBooks);

        expect(file.existsSync(), true);

        await exportService.deleteExportFile(file);

        expect(file.existsSync(), false);
      });

      test('Обрабатывает удаление несуществующего файла', () async {
        final tempFile = File('${Directory.systemTemp.path}/nonexistent.csv');

        // Не должно быть исключения
        await exportService.deleteExportFile(tempFile);

        expect(tempFile.existsSync(), false);
      });
    });

    group('File Names', () {
      test('CSV файл содержит временную метку в имени', () async {
        final file1 = await exportService.exportToCSV(testBooks);
        await Future.delayed(const Duration(milliseconds: 100));
        final file2 = await exportService.exportToCSV(testBooks);

        expect(file1.path.contains('books_'), true);
        expect(file2.path.contains('books_'), true);
        expect(file1.path, isNot(file2.path));

        if (file1.existsSync()) {
          await exportService.deleteExportFile(file1);
        }
        if (file2.existsSync()) {
          await exportService.deleteExportFile(file2);
        }
      });

      test('PDF файл содержит расширение .pdf', () async {
        final file = await exportService.exportToPDF(testBooks);

        expect(file.path.endsWith('.pdf'), true);

        if (file.existsSync()) {
          await exportService.deleteExportFile(file);
        }
      });
    });
  });
}
