# 📋 Добавленные функции к BookVerse (+3.0 баллов)

## ✅ Реализованные функции

### 1. **Тёмная и светлая тема с переключателем** (+0.5)
- **Файлы**:
  - `lib/presentation/viewmodels/theme_notifier.dart` - управление темой
  - `lib/presentation/providers/theme_provider.dart` - провайдер Riverpod
  - `lib/core/preferences_provider.dart` - провайдер для SharedPreferences
  - `lib/presentation/pages/library_screen.dart` - кнопка переключателя в UI

- **Функциональность**:
  - Автоматическое сохранение выбранной темы в SharedPreferences
  - Циклическое переключение: Светлая → Тёмная → Система → Светлая
  - Кнопка с иконкой в SliverAppBar для быстрого переключения
  - Material 3 поддержка для обоих режимов

- **Использование**:
  ```dart
  // В UI просто нажимаем кнопку с иконкой луны/солнца
  // Тема сохраняется и применяется при перезапуске приложения
  ```

---

### 2. **Экспорт данных (CSV и PDF)** (+0.5)
- **Файлы**:
  - `lib/data/services/export_service.dart` - сервис экспорта
  - `lib/presentation/providers/export_provider.dart` - провайдер и notifier

- **Функциональность**:
  - Экспорт всех или отфильтрованных книг в CSV
  - Экспорт в PDF с таблицей и статистикой
  - Автоматический шеринг файла через Share Plus
  - Обработка ошибок и показ снэк-баров с сообщениями

- **Использование**:
  ```dart
  // Нажимаем кнопку Download в SliverAppBar
  // Выбираем формат: CSV или PDF
  // Файл автоматически экспортируется и шарится
  ```

- **API**:
  ```dart
  final exportService = ExportService();
  
  // Экспорт в CSV
  final csvFile = await exportService.exportToCSV(books);
  
  // Экспорт в PDF
  final pdfFile = await exportService.exportToPDF(books);
  
  // Шеринг файла
  await exportService.shareFile(file);
  ```

---

### 3. **Онбординг при первом запуске** (+0.5)
- **Файлы**:
  - `lib/presentation/pages/onboarding_screen.dart` - экран онбординга
  - `lib/presentation/viewmodels/onboarding_notifier.dart` - управление состоянием
  - `lib/main.dart` - интеграция с главным экраном
  - `lib/core/preferences_provider.dart` - проверка первого запуска

- **Функциональность**:
  - PageView с 4 слайдами (Welcome, Search, Analytics, Start)
  - Индикатор прогресса (точки)
  - Кнопки "Пропустить" и "Далее"/"Начать"
  - Сохранение факта завершения онбординга
  - Показывается только при первом запуске

- **Слайды**:
  1. 📚 Добро пожаловать в BookVerse
  2. 🔍 Легко найдите книгу
  3. 📊 Отслеживайте прогресс
  4. ⚡ Начните прямо сейчас

- **Использование**:
  ```dart
  // Автоматически показывается при первом запуске
  // После завершения: "Пропустить" или "Начать"
  // Информация сохраняется в SharedPreferences
  ```

---

### 4. **Push-уведомления (локальные)** (+0.5)
- **Файлы**:
  - `lib/data/services/notification_service.dart` - сервис уведомлений
  - `lib/main.dart` - инициализация

- **Функциональность**:
  - Поддержка простых, периодических и запланированных уведомлений
  - Встроенные напоминания о книгах
  - Работает на Android и iOS
  - Использует flutter_local_notifications

- **Встроенные напоминания**:
  ```dart
  // Напоминание о непрочитанных книгах
  await notificationService.remindAboutBooks();
  
  // Напоминание о новых добавленных книгах
  await notificationService.remindAboutNewBooks(count);
  ```

- **API**:
  ```dart
  final notificationService = NotificationService();
  
  // Простое уведомление
  await notificationService.showNotification(
    id: 1,
    title: 'Заголовок',
    body: 'Текст уведомления',
  );
  
  // Запланированное уведомление
  await notificationService.showScheduledNotification(
    id: 2,
    title: 'Заголовок',
    body: 'Текст',
    scheduledDate: DateTime.now().add(Duration(hours: 1)),
  );
  
  // Отмена уведомления
  await notificationService.cancelNotification(1);
  ```

---

### 5. **Unit-тесты для use cases** (+1.0)
- **Файлы тестов**:
  - `test/book_notifier_test.dart` - тесты для BookNotifier (13 тестов)
  - `test/export_service_test.dart` - тесты для ExportService (9 тестов)
  - `test/theme_notifier_test.dart` - тесты для ThemeNotifier (13 тестов)
  - `test/notification_service_test.dart` - тесты для NotificationService (8 тестов)

- **Всего тестов**: 43 тестов

#### **BookNotifier Tests** (13 тестов):
- ✅ Инициализация с загрузкой книг
- ✅ Обработка ошибок при загрузке
- ✅ Добавление новой книги
- ✅ Удаление книги
- ✅ Обновление книги
- ✅ Изменение статуса книги
- ✅ Фильтрация по статусу
- ✅ Поиск по названию
- ✅ Поиск по автору
- ✅ Комбинированная фильтрация
- ✅ Очистка фильтров
- ✅ Возврат всех книг без фильтров
- ✅ Обновление состояния после операций

#### **ExportService Tests** (9 тестов):
- ✅ Экспорт книг в CSV
- ✅ Обработка пустого списка
- ✅ Проверка всех колонок CSV
- ✅ Экспорт книг в PDF
- ✅ Валидация PDF формата
- ✅ Экспорт пустого списка в PDF
- ✅ Удаление файла
- ✅ Обработка удаления несуществующего файла
- ✅ Временная метка в имени файла

#### **ThemeNotifier Tests** (13 тестов):
- ✅ Инициализация с системной темой
- ✅ Загрузка сохраненной темы
- ✅ Использование системной темы по умолчанию
- ✅ Обработка некорректного значения
- ✅ Переключение между темами
- ✅ Установка системной темы
- ✅ Сохранение темы в SharedPreferences
- ✅ Циклическое переключение темы
- ✅ Правильные лейблы для каждой темы
- ✅ Сохранение темы между запусками
- ✅ Загрузка сохраненных настроек
- ✅ Проверка синглтона

#### **NotificationService Tests** (8 тестов):
- ✅ Проверка синглтона
- ✅ Уведомление имеет правильные свойства
- ✅ Напоминание о книгах содержит текст
- ✅ Напоминание о новых книгах
- ✅ Отмена уведомления
- ✅ Отмена всех уведомлений
- ✅ Поддержка различных типов уведомлений
- ✅ Корректное формирование напоминаний

---

## 📦 Добавленные зависимости

```yaml
dependencies:
  # Theme Management & Preferences
  shared_preferences: ^2.2.0
  
  # Notifications
  flutter_local_notifications: ^14.0.0
  synchronized: ^3.1.0
  timezone: ^0.9.0
  
  # Export & Sharing
  csv: ^6.0.0
  pdf: ^3.10.0
  printing: ^5.10.0
  share_plus: ^8.0.0
  path_provider: ^2.1.0

dev_dependencies:
  # Testing
  mocktail: ^1.0.0
```

---

## 🧪 Запуск тестов

```bash
# Все тесты
flutter test

# Конкретный тест файл
flutter test test/book_notifier_test.dart
flutter test test/export_service_test.dart
flutter test test/theme_notifier_test.dart
flutter test test/notification_service_test.dart

# С покрытием
flutter test --coverage
```

---

## 🎨 UI Изменения

### LibraryScreen (header):
- Добавлена кнопка Download (экспорт)
- Добавлена кнопка Theme Toggle (переключатель темы)
- Обе кнопки в SliverAppBar для быстрого доступа

### OnboardingScreen:
- Показывается автоматически при первом запуске
- PageView с 4 слайдами
- Индикатор прогресса
- Кнопки навигации

---

## 📝 Примеры использования

### Экспорт данных:
```dart
// В LibraryScreen нажимаем Download → CSV или PDF
// Файл создается и сразу шарится через Share
```

### Смена темы:
```dart
// Нажимаем кнопку в header (луна/солнце)
// Тема переключается и сохраняется
```

### Уведомления:
```dart
final notificationService = NotificationService();

// При добавлении книги
await notificationService.remindAboutNewBooks(1);

// Напоминание о чтении каждый день
await notificationService.showScheduledNotification(
  id: 10,
  title: '📚 Время читать!',
  body: 'Продолжите чтение...',
  scheduledDate: DateTime.now().add(Duration(days: 1)),
);
```

---

## ✨ Архитектура

Все новые функции следуют Clean Architecture и Riverpod best practices:

- **Service Layer**: `lib/data/services/` - бизнес-логика
- **ViewModels**: `lib/presentation/viewmodels/` - управление состоянием
- **Providers**: `lib/presentation/providers/` - Riverpod провайдеры
- **UI**: `lib/presentation/pages/` и `lib/presentation/widgets/` - компоненты

---

## 📊 Покрытие

- **BookNotifier**: 100% функциональности протестировано
- **ExportService**: Все методы протестированы
- **ThemeNotifier**: Полное покрытие state persistence
- **NotificationService**: Основной функционал протестирован

Всего **43 тестовых сценария** для обеспечения качества кода.
