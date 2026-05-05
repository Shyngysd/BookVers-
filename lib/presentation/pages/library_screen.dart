import 'package:bookvers/domain/entities/book.dart';
import 'package:bookvers/presentation/pages/add_edit_book_screen.dart';
import 'package:bookvers/presentation/providers/book_presentation_providers.dart';
import 'package:bookvers/presentation/providers/export_provider.dart';
import 'package:bookvers/presentation/providers/theme_provider.dart';
import 'package:bookvers/presentation/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  late TextEditingController _searchController;
  BookStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Инициализируем BookNotifier при загрузке экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookNotifierProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Очистить поиск и фильтры
  void _clearFilters() {
    _searchController.clear();
    setState(() => _selectedStatus = null);
    ref.read(bookNotifierProvider.notifier).clearFilters();
  }

  /// Показать диалог для добавления книги
  void _showAddBookDialog() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddEditBookScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = ref.watch(filteredBooksProvider);
    final hasFilters = ref.watch(hasActiveFiltersProvider);
    final bookNotifier = ref.read(bookNotifierProvider.notifier);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar с поиском
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Consumer(
                  builder: (context, ref, child) {
                    final exportState = ref.watch(exportProvider);
                    final exportNotifier = ref.read(exportProvider.notifier);
                    final filteredBooks = ref.watch(filteredBooksProvider);

                    return PopupMenuButton(
                      icon: const Icon(Icons.download),
                      tooltip: 'Экспортировать',
                      onSelected: (value) async {
                        final ctx = context;
                        
                        if (filteredBooks.isEmpty) {
                          if (mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                content: Text('Нечего экспортировать'),
                              ),
                            );
                          }
                          return;
                        }

                        if (value == 'csv') {
                          await exportNotifier.exportToCSV(filteredBooks);
                        } else if (value == 'pdf') {
                          await exportNotifier.exportToPDF(filteredBooks);
                        }

                        if (mounted && exportState.successMessage != null) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                              content: Text(exportState.successMessage!),
                            ),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(
                          value: 'csv',
                          child: Text('Экспорт в CSV'),
                        ),
                        const PopupMenuItem(
                          value: 'pdf',
                          child: Text('Экспорт в PDF'),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Consumer(
                  builder: (context, ref, child) {
                    final themeNotifier = ref.read(
                      themeProvider.notifier,
                    );
                    return IconButton(
                      icon: Icon(
                        ref.watch(themeProvider) == ThemeMode.dark
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                      tooltip: 'Переключить тему',
                      onPressed: () async {
                        await themeNotifier.toggleTheme();
                      },
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Моя библиотека'),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Панель поиска и фильтрации
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Поле поиска
                  TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      bookNotifier.setSearchQuery(query);
                    },
                    decoration: InputDecoration(
                      hintText: 'Поиск по названию или автору...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                bookNotifier.setSearchQuery('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Чипы для фильтрации по статусу
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Чип "Все"
                        FilterChip(
                          label: const Text('Все'),
                          selected: _selectedStatus == null,
                          onSelected: (selected) {
                            setState(() => _selectedStatus = null);
                            bookNotifier.setStatusFilter(null);
                          },
                        ),
                        const SizedBox(width: 8),

                        // Чип "Доступна"
                        FilterChip(
                          label: const Text('Доступна'),
                          selected: _selectedStatus == BookStatus.available,
                          onSelected: (selected) {
                            setState(
                              () => _selectedStatus = selected
                                  ? BookStatus.available
                                  : null,
                            );
                            bookNotifier.setStatusFilter(
                              selected ? BookStatus.available : null,
                            );
                          },
                        ),
                        const SizedBox(width: 8),

                        // Чип "Выдана"
                        FilterChip(
                          label: const Text('Выдана'),
                          selected: _selectedStatus == BookStatus.borrowed,
                          onSelected: (selected) {
                            setState(
                              () => _selectedStatus = selected
                                  ? BookStatus.borrowed
                                  : null,
                            );
                            bookNotifier.setStatusFilter(
                              selected ? BookStatus.borrowed : null,
                            );
                          },
                        ),
                        const SizedBox(width: 8),

                        // Чип "Зарезервирована"
                        FilterChip(
                          label: const Text('Зарезервирована'),
                          selected: _selectedStatus == BookStatus.reserved,
                          onSelected: (selected) {
                            setState(
                              () => _selectedStatus = selected
                                  ? BookStatus.reserved
                                  : null,
                            );
                            bookNotifier.setStatusFilter(
                              selected ? BookStatus.reserved : null,
                            );
                          },
                        ),
                        const SizedBox(width: 8),

                        // Чип "Недоступна"
                        FilterChip(
                          label: const Text('Недоступна'),
                          selected: _selectedStatus == BookStatus.unavailable,
                          onSelected: (selected) {
                            setState(
                              () => _selectedStatus = selected
                                  ? BookStatus.unavailable
                                  : null,
                            );
                            bookNotifier.setStatusFilter(
                              selected ? BookStatus.unavailable : null,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Кнопка очистить фильтры
                  if (hasFilters)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextButton.icon(
                        onPressed: _clearFilters,
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Очистить фильтры'),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Список книг
          if (filteredBooks.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.library_books,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      hasFilters
                          ? 'Книги не найдены'
                          : 'Нет книг в библиотеке',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    if (hasFilters)
                      TextButton.icon(
                        onPressed: _clearFilters,
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Очистить фильтры'),
                      ),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final book = filteredBooks[index];
                  return BookCard(
                    book: book,
                    onTap: () {
                      // TODO: Переход на BookDetailScreen
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Открыть: ${book.title}'),
                        ),
                      );
                    },
                    onEdit: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AddEditBookScreen(book: book),
                        ),
                      );
                    },
                    onDelete: () {
                      // Показать диалог удаления
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Удалить книгу?'),
                          content: Text(
                            'Вы уверены, что хотите удалить "${book.title}"?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Отмена'),
                            ),
                            TextButton(
                              onPressed: () {
                                bookNotifier.deleteBook(book.id);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Книга удалена'),
                                  ),
                                );
                              },
                              child: const Text(
                                'Удалить',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    onRead: () async {
                      final ctx = context;
                      final success = await bookNotifier.openBookUrl(book.url);
                      if (!success && mounted) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text('Не удалось открыть ссылку'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  );
                },
                childCount: filteredBooks.length,
              ),
            ),
        ],
      ),

      // FloatingActionButton для добавления книги
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBookDialog,
        tooltip: 'Добавить книгу',
        child: const Icon(Icons.add),
      ),
    );
  }
}
