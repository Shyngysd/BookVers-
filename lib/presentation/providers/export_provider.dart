import 'package:bookvers/data/services/export_service.dart';
import 'package:bookvers/domain/entities/book.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State для экспорта
class ExportState {
  final bool isLoading;
  final String? error;
  final String? successMessage;

  ExportState({
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  ExportState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return ExportState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

/// Notifier для управления экспортом
class ExportNotifier extends StateNotifier<ExportState> {
  final ExportService _exportService = ExportService();

  ExportNotifier() : super(ExportState());

  /// Экспортирует книги в CSV
  Future<void> exportToCSV(List<Book> books) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final file = await _exportService.exportToCSV(books);
      await _exportService.shareFile(file);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'CSV файл успешно создан и отправлен',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Ошибка при экспорте CSV: $e',
      );
    }
  }

  /// Экспортирует книги в PDF
  Future<void> exportToPDF(List<Book> books) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final file = await _exportService.exportToPDF(books);
      await _exportService.shareFile(file);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'PDF файл успешно создан и отправлен',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Ошибка при экспорте PDF: $e',
      );
    }
  }

  /// Очищает сообщения
  void clearMessages() {
    state = ExportState();
  }
}

/// Provider для ExportNotifier
final exportProvider =
    StateNotifierProvider<ExportNotifier, ExportState>((ref) {
  return ExportNotifier();
});
