import 'package:bookvers/domain/entities/book.dart';
import 'package:bookvers/domain/repositories/book_repository.dart';
import 'package:bookvers/presentation/viewmodels/book_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock классы
class MockBookRepository extends Mock implements IBookRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const Book(
        id: 0,
        title: 'Fallback',
        author: 'Fallback',
        description: '',
        status: BookStatus.available,
        genreId: 1,
        url: null,
      ),
    );
  });

  group('BookNotifier Tests', () {
    late BookNotifier bookNotifier;
    late MockBookRepository mockRepository;

    setUp(() {
      mockRepository = MockBookRepository();
      bookNotifier = BookNotifier(mockRepository);
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
        url: null,
      ),
      const Book(
        id: 2,
        title: '1984',
        author: 'Джордж Оруэлл',
        description: 'Антиутопия',
        status: BookStatus.borrowed,
        genreId: 2,
        url: null,
      ),
      const Book(
        id: 3,
        title: 'О дивный новый мир',
        author: 'Олдос Хаксли',
        description: 'Антиутопия',
        status: BookStatus.reserved,
        genreId: 2,
        url: null,
      ),
    ];

    group('Initialize', () {
      test('Успешно загружает все книги при инициализации', () async {
        when(() => mockRepository.getAllBooks())
            .thenAnswer((_) async => testBooks);

        await bookNotifier.initialize();

        expect(bookNotifier.state.books.length, 3);
        expect(bookNotifier.state.books, testBooks);
        verify(() => mockRepository.getAllBooks()).called(1);
      });

      test('Обрабатывает ошибку при загрузке книг', () async {
        when(() => mockRepository.getAllBooks())
            .thenThrow(Exception('Database error'));

        expect(
          () => bookNotifier.initialize(),
          throwsException,
        );
      });
    });

    group('CRUD Operations', () {
      test('Добавляет новую книгу', () async {
        when(() => mockRepository.getAllBooks())
            .thenAnswer((_) async => testBooks);
        when(() => mockRepository.createBook(any()))
            .thenAnswer((_) async => {});

        final newBook = const Book(
          id: 4,
          title: 'Граф Монте-Кристо',
          author: 'Александр Дюма',
          description: 'Приключения',
          status: BookStatus.available,
          genreId: 1,
        );

        await bookNotifier.addBook(newBook);

        verify(() => mockRepository.createBook(newBook)).called(1);
        verify(() => mockRepository.getAllBooks()).called(1);
      });

      test('Удаляет книгу по ID', () async {
        when(() => mockRepository.getAllBooks())
            .thenAnswer((_) async => testBooks);
        when(() => mockRepository.deleteBook(1))
            .thenAnswer((_) async => {});

        await bookNotifier.deleteBook(1);

        verify(() => mockRepository.deleteBook(1)).called(1);
        verify(() => mockRepository.getAllBooks()).called(1);
      });

      test('Обновляет существующую книгу', () async {
        when(() => mockRepository.getAllBooks())
            .thenAnswer((_) async => testBooks);
        when(() => mockRepository.updateBook(any()))
            .thenAnswer((_) async => {});

        const updatedBook = Book(
          id: 1,
          title: 'Война и мир (обновлено)',
          author: 'Лев Толстой',
          description: 'Исторический роман',
          status: BookStatus.borrowed,
          genreId: 1,
        );

        await bookNotifier.updateBook(updatedBook);

        verify(() => mockRepository.updateBook(updatedBook)).called(1);
        verify(() => mockRepository.getAllBooks()).called(1);
      });

      test('Изменяет статус книги', () async {
        when(() => mockRepository.getAllBooks())
            .thenAnswer((_) async => testBooks);
        when(() => mockRepository.updateBookStatus(1, BookStatus.borrowed))
            .thenAnswer((_) async => {});

        await bookNotifier.updateBookStatus(1, BookStatus.borrowed);

        verify(() => mockRepository.updateBookStatus(1, BookStatus.borrowed))
            .called(1);
        verify(() => mockRepository.getAllBooks()).called(1);
      });
    });

    group('Фильтрация и поиск', () {
      setUp(() async {
        when(() => mockRepository.getAllBooks())
            .thenAnswer((_) async => testBooks);
        await bookNotifier.initialize();
      });

      test('Фильтрует книги по статусу "Доступна"', () {
        bookNotifier.setStatusFilter(BookStatus.available);

        final filtered = bookNotifier.state.filteredBooks;

        expect(filtered.length, 1);
        expect(filtered.first.status, BookStatus.available);
      });

      test('Ищет книги по названию', () {
        bookNotifier.setSearchQuery('война');

        final filtered = bookNotifier.state.filteredBooks;

        expect(filtered.length, 1);
        expect(filtered.first.title, 'Война и мир');
      });

      test('Ищет книги по автору', () {
        bookNotifier.setSearchQuery('толстой');

        final filtered = bookNotifier.state.filteredBooks;

        expect(filtered.length, 1);
        expect(filtered.first.author, 'Лев Толстой');
      });

      test('Комбинирует фильтр по статусу и поиск', () {
        bookNotifier.setStatusFilter(BookStatus.reserved);
        bookNotifier.setSearchQuery('новый мир');

        final filtered = bookNotifier.state.filteredBooks;

        expect(filtered.length, 1);
        expect(filtered.first.title, 'О дивный новый мир');
      });

      test('Очищает все фильтры', () {
        bookNotifier.setStatusFilter(BookStatus.available);
        bookNotifier.setSearchQuery('война');

        bookNotifier.clearFilters();

        expect(bookNotifier.state.searchQuery, '');
        expect(bookNotifier.state.statusFilter, null);
        expect(bookNotifier.state.filteredBooks.length, 3);
      });

      test('Возвращает все книги если нет фильтров', () {
        final filtered = bookNotifier.state.filteredBooks;

        expect(filtered.length, 3);
        expect(filtered, testBooks);
      });
    });

    group('State Management', () {
      test('Состояние обновляется после добавления книги', () async {
        when(() => mockRepository.getAllBooks())
            .thenAnswer((_) async => testBooks);
        when(() => mockRepository.createBook(any()))
            .thenAnswer((_) async => {});

        const newBook = Book(
          id: 4,
          title: 'Новая книга',
          author: 'Автор',
          description: 'Описание',
          status: BookStatus.reserved,
          genreId: 1,
        );

        await bookNotifier.addBook(newBook);

        expect(bookNotifier.state.books.length, 3);
      });
    });
  });
}
