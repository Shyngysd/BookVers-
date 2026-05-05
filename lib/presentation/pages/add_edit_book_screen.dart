import 'package:bookvers/data/providers/book_providers.dart';
import 'package:bookvers/domain/entities/book.dart';
import 'package:bookvers/presentation/providers/book_presentation_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEditBookScreen extends ConsumerStatefulWidget {
  final Book? book; // null для добавления, не null для редактирования

  const AddEditBookScreen({super.key, this.book});

  @override
  ConsumerState<AddEditBookScreen> createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends ConsumerState<AddEditBookScreen> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _descriptionController;
  late TextEditingController _urlController;
  late BookStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book?.title ?? '');
    _authorController = TextEditingController(text: widget.book?.author ?? '');
    _descriptionController =
        TextEditingController(text: widget.book?.description ?? '');
    _urlController = TextEditingController(text: widget.book?.url ?? '');
    _selectedStatus = widget.book?.status ?? BookStatus.available;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _saveBook() async {
    if (_titleController.text.isEmpty || _authorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Заполните название и автора'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final bookNotifier = ref.read(bookNotifierProvider.notifier);

    try {
      if (widget.book == null) {
        // Добавление новой книги - генерируем ID автоинкрементом
        // Берем максимальный ID из существующих книг
        final allBooks = await ref.read(bookRepositoryProvider).getAllBooks();
        final maxId =
            allBooks.isEmpty ? 0 : allBooks.map((b) => b.id).reduce((a, b) => a > b ? a : b);
        final newId = maxId + 1;

        final newBook = Book(
          id: newId,
          title: _titleController.text,
          author: _authorController.text,
          description: _descriptionController.text,
          status: _selectedStatus,
          genreId: 1, // Дефолтный жанр
          url: _urlController.text.isEmpty ? null : _urlController.text,
        );
        await bookNotifier.addBook(newBook);
      } else {
        // Редактирование существующей книги
        final updatedBook = widget.book!.copyWith(
          title: _titleController.text,
          author: _authorController.text,
          description: _descriptionController.text,
          status: _selectedStatus,
          url: _urlController.text.isEmpty ? null : _urlController.text,
        );
        await bookNotifier.updateBook(updatedBook);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.book == null ? 'Книга добавлена' : 'Книга обновлена',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.book != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать книгу' : 'Добавить книгу'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Название
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Название книги *',
                hintText: 'Введите название',
                prefixIcon: const Icon(Icons.book),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Автор
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Автор *',
                hintText: 'Введите имя автора',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Описание
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Описание',
                hintText: 'Введите описание книги',
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            // Ссылка на книгу
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Ссылка на книгу',
                hintText: 'https://example.com/book',
                prefixIcon: const Icon(Icons.link),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),

            // Статус
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<BookStatus>(
                value: _selectedStatus,
                isExpanded: true,
                underline: const SizedBox(),
                items: BookStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(_getStatusLabel(status)),
                  );
                }).toList(),
                onChanged: (status) {
                  if (status != null) {
                    setState(() => _selectedStatus = status);
                  }
                },
              ),
            ),
            const SizedBox(height: 32),

            // Кнопки
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Отмена'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _saveBook,
                    child: Text(isEditing ? 'Обновить' : 'Сохранить'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(BookStatus status) {
    switch (status) {
      case BookStatus.available:
        return 'Доступна';
      case BookStatus.borrowed:
        return 'Выдана';
      case BookStatus.reserved:
        return 'Зарезервирована';
      case BookStatus.unavailable:
        return 'Недоступна';
    }
  }
}
