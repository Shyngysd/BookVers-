# 📖 BookVerse — Your Personal Library Tracker

**BookVerse** — это мобильное приложение на Flutter для управления личной библиотекой. Проект выполнен в качестве выпускной работы курса **DataGroup Academy**.

## 🚀 Функционал (MVP)
*   **Авторизация**: Вход и регистрация через Email/Пароль (Firebase/Mock).
*   **Управление книгами (CRUD)**: Добавление, редактирование, просмотр деталей и удаление книг.
*   **Умный поиск**: Живой поиск по названию и автору.
*   **Фильтрация**: Сортировка по статусу (В процессе, Прочитано, Хочу прочитать).
*   **Аналитика**: Визуализация прогресса чтения и распределения жанров с помощью `fl_chart`.
*   **Offline-first**: Полная работоспособность без интернета благодаря локальной базе данных.

## 🏗 Архитектура
Приложение построено по принципам **Clean Architecture** с разделением на слои:
*   `presentation`: UI-виджеты и управление состоянием через **Riverpod**.
*   `domain`: Бизнес-логика, Entities (Book, Genre) и интерфейсы репозиториев.
*   `data`: Реализация репозиториев, работа с **Hive** (Local DB) и API (Dio).
*   `core`: Общие темы (Material 3), роутинг (**go_router**) и утилиты.

## 🛠 Технологический стек
*   **Framework**: Flutter (Material 3)
*   **State Management**: Riverpod (AsyncNotifier)
*   **Navigation**: go_router
*   **Database**: Hive
*   **Charts**: fl_chart
*   **Code Generation**: Freezed, Hive Generator

---

## 📋 Реализация

### ✅ Domain слой (lib/domain)
**Entities:**
- `Book` (freezed): id, title, author, description, status, genreId + enum BookStatus
- `Genre` (freezed): id, name, description

**Repositories (Абстрактные):**
- `IBookRepository`: getAllBooks, getBookById, getBooksByGenre, getBooksByStatus, createBook, updateBook, deleteBook, deleteAllBooks, updateBookStatus, searchBooks
- `IGenreRepository`: getAllGenres, getGenreById, createGenre, updateGenre, deleteGenre

### ✅ Data слой (lib/data)
**Models:**
- `BookModel`: расширяет Book для Hive с методами toDomain() и fromDomain()
- `GenreModel`: расширяет Genre для Hive

**TypeAdapters (Hive):**
- `BookModelAdapter` (typeId: 0): ручное сохранение/загрузка BookModel
- `GenreModelAdapter` (typeId: 1): ручное сохранение/загрузка GenreModel

**DataSource:**
- `ILocalDataSource` (абстрактный): интерфейс для локальных операций
- `HiveLocalDataSource`: имплементация CRUD операций с Hive

**Repository:**
- `HiveBookRepository`: имплементирует IBookRepository, конвертирует модели в domain entities

**Providers (Riverpod):**
- `localDataSourceProvider`: провайдер для Hive datasource
- `bookRepositoryProvider`: провайдер для репозитория
- `allBooksProvider`: FutureProvider для получения всех книг
- `bookByIdProvider`: FutureProvider.family для получения книги по ID
- `booksByGenreProvider`: FutureProvider.family для получения книг по жанру
- `searchBooksProvider`: FutureProvider.family для поиска

**Инициализация:**
- `lib/core/init_hive.dart`: функция initHive() регистрирует адаптеры
- `lib/main.dart`: интеграция ProviderScope и инициализация Hive