import 'package:bookvers/data/models/adapters/book_model_adapter.dart';
import 'package:bookvers/data/models/adapters/genre_model_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Инициализирует Hive и регистрирует все адаптеры
Future<void> initHive() async {
  // Инициализируем Hive
  await Hive.initFlutter();

  // Регистрируем адаптеры
  Hive.registerAdapter(BookModelAdapter());
  Hive.registerAdapter(GenreModelAdapter());
}
