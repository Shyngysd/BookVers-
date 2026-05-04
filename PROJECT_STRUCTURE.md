# 📁 BookVerse Project Structure

## Quick Navigation

### 🏗️ Architecture Layers

#### **Domain** (Business Logic - No Flutter)
```
lib/domain/
├── entities/
│   ├── book.dart                  # Book entity (id, title, author, etc.)
│   ├── genre.dart                 # Genre entity
│   └── index.dart                 # Exports
├── repositories/
│   ├── book_repository.dart       # IBookRepository interface
│   ├── genre_repository.dart      # IGenreRepository interface
│   └── index.dart                 # Exports
└── index.dart                     # Main exports
```

#### **Data** (External Data Sources - Hive, API, etc.)
```
lib/data/
├── datasources/
│   ├── hive_local_datasource.dart # CRUD with Hive
│   └── index.dart
├── models/
│   ├── book_model.dart            # BookModel + toDomain/fromDomain
│   ├── genre_model.dart           # GenreModel + toDomain/fromDomain
│   ├── adapters/
│   │   ├── book_model_adapter.dart    # TypeAdapter for Hive (typeId: 0)
│   │   ├── genre_model_adapter.dart   # TypeAdapter for Hive (typeId: 1)
│   │   └── index.dart
│   └── index.dart
├── repositories/
│   ├── book_repository_impl.dart  # HiveBookRepository implementation
│   └── index.dart
├── providers/
│   ├── book_providers.dart        # Data layer providers
│   └── index.dart
└── index.dart                     # Main exports
```

#### **Presentation** (UI - Widgets & State Management)
```
lib/presentation/
├── viewmodels/
│   ├── book_notifier.dart         # StateNotifier for book management
│   ├── book_view_state.dart       # State holder + filtering logic
│   └── index.dart
├── providers/
│   ├── book_presentation_providers.dart  # UI providers (bookNotifierProvider, etc.)
│   └── index.dart
├── pages/
│   ├── library_screen.dart        # Main library screen (SliverAppBar + ListView)
│   └── index.dart
├── widgets/
│   ├── book_card.dart             # Book card widget (Material 3)
│   └── index.dart
└── index.dart                     # Main exports
```

#### **Core** (App Setup & Constants)
```
lib/core/
└── init_hive.dart                 # initHive() - register Hive adapters
```

### 🚀 Main Files
- **lib/main.dart** - App entry point (Material 3, ProviderScope, LibraryScreen)

---

## 📊 Data Flow

```
Domain (Book, IBookRepository)
    ↓
Data (BookModel, HiveBookRepository, Hive adapters)
    ↓
Presentation (BookNotifier, BookViewState, LibraryScreen)
    ↓
UI (BookCard, FilterChips, SearchBar)
```

---

## 🔑 Key Features

✅ **Search & Filtering**
- Live search by title/author
- Filter by book status
- Clear filters button

✅ **CRUD Operations**
- Add book (FAB)
- Edit book (popup menu)
- Delete book (popup menu + confirmation)
- Change book status

✅ **Material 3**
- ColorScheme.fromSeed (Indigo)
- Light & Dark themes
- Gradient SliverAppBar

✅ **State Management**
- Riverpod (StateNotifierProvider)
- Reactive updates
- Clean separation of concerns

✅ **Local Storage**
- Hive (offline-first)
- TypeAdapters for serialization
- No internet required

---

## 📱 Screens (TODO)

- [x] **LibraryScreen** - Main library with search, filter, list
- [ ] **AddEditBookScreen** - Create/edit book
- [ ] **BookDetailScreen** - View book details
- [ ] **Navigation** (go_router integration)

---

## 🛠️ Development Tips

### Run app
```bash
flutter run
```

### Analyze code
```bash
flutter analyze
```

### Generate code (freezed, hive_generator)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Check dependencies
```bash
flutter pub outdated
```

---

## 📦 Dependencies

- **flutter_riverpod** - State management
- **hive** - Local database
- **go_router** - Navigation
- **freezed** - Code generation (immutability)
- **freezed_annotation** - Annotations

---

## ⚙️ Architecture Principles

1. **Separation of Concerns** - Domain, Data, Presentation layers
2. **Dependency Injection** - Riverpod providers
3. **Offline-First** - Hive local storage
4. **Immutability** - Freezed & ValueObjects
5. **No Flutter in Domain** - Pure business logic

---

Generated: May 4, 2026
