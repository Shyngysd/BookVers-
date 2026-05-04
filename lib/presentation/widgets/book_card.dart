import 'package:bookvers/domain/entities/book.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  /// Получить цвет чипа по статусу
  Color _getStatusColor(BookStatus status) {
    switch (status) {
      case BookStatus.available:
        return Colors.green;
      case BookStatus.borrowed:
        return Colors.blue;
      case BookStatus.reserved:
        return Colors.orange;
      case BookStatus.unavailable:
        return Colors.red;
    }
  }

  /// Получить текст статуса
  String _getStatusText(BookStatus status) {
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          book.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Автор: ${book.author}',
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Chip(
              label: Text(_getStatusText(book.status)),
              backgroundColor: _getStatusColor(book.status).withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: _getStatusColor(book.status),
                fontWeight: FontWeight.w500,
              ),
              side: BorderSide(
                color: _getStatusColor(book.status),
              ),
            ),
          ],
        ),
        onTap: onTap,
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            if (onEdit != null)
              PopupMenuItem(
                onTap: onEdit,
                child: const Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Редактировать'),
                  ],
                ),
              ),
            if (onDelete != null)
              PopupMenuItem(
                onTap: onDelete,
                child: const Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Удалить', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
