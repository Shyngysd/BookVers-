import 'dart:io';

import 'package:bookvers/domain/entities/book.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class ExportService {
  /// Экспортирует список книг в CSV файл
  Future<File> exportToCSV(List<Book> books) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/books_$timestamp.csv');

    // Подготавливаем данные для CSV
    final List<List<dynamic>> rows = [
      ['Название', 'Автор', 'Описание', 'Статус', 'Жанр ID'],
    ];

    for (final book in books) {
      rows.add([
        book.title,
        book.author,
        book.description,
        book.status.toString().split('.').last,
        book.genreId.toString(),
      ]);
    }

    // Конвертируем в CSV
    final csv = const ListToCsvConverter().convert(rows);

    // Записываем в файл
    await file.writeAsString(csv);

    return file;
  }

  /// Экспортирует список книг в PDF файл
  Future<File> exportToPDF(List<Book> books) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/books_$timestamp.pdf');

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Моя библиотека BookVerse',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Всего книг: ${books.length}',
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              // Заголовок таблицы
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Название',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Автор',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Статус',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
              // Строки с данными
              ...books.map(
                (book) => pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        book.title,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        book.author,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        book.status.toString().split('.').last,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Экспортировано: ${DateTime.now().toString()}',
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey,
            ),
          ),
        ],
      ),
    );

    await file.writeAsBytes(await pdf.save());

    return file;
  }

  /// Делится файлом через Share API
  Future<void> shareFile(File file) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Мой список книг из BookVerse',
    );
  }

  /// Удаляет файл экспорта
  Future<void> deleteExportFile(File file) async {
    if (await file.exists()) {
      await file.delete();
    }
  }
}
