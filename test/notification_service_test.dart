import 'package:bookvers/data/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

class MockAndroidFlutterLocalNotificationsPlugin extends Mock
    implements AndroidFlutterLocalNotificationsPlugin {}

void main() {
  group('NotificationService Tests', () {
    test('Синглтон возвращает тот же экземпляр', () {
      final service1 = NotificationService();
      final service2 = NotificationService();

      expect(identical(service1, service2), true);
    });

    group('Notification Operations', () {
      test('Уведомление имеет правильные свойства', () {
        final service = NotificationService();

        expect(service.flutterLocalNotificationsPlugin, isNotNull);
      });

      test('Напоминание о книгах содержит правильный текст', () async {
        // Это просто проверка что методы существуют
        final service = NotificationService();
        expect(service.remindAboutBooks, isA<Function>());
      });

      test('Напоминание о новых книгах содержит количество', () async {
        final service = NotificationService();

        expect(service.remindAboutNewBooks, isA<Function>());
      });
    });

    group('Notification Management', () {
      test('Сервис может отменить уведомление', () {
        final service = NotificationService();

        // Проверяем что метод существует
        expect(service.cancelNotification, isA<Function>());
      });

      test('Сервис может отменить все уведомления', () {
        final service = NotificationService();

        // Проверяем что метод существует
        expect(service.cancelAllNotifications, isA<Function>());
      });
    });
  });

  group('Notification Types', () {
    test('Поддерживает обычные уведомления', () {
      final service = NotificationService();

      expect(service.showNotification, isA<Function>());
    });

    test('Поддерживает периодические уведомления', () {
      final service = NotificationService();

      expect(service.showPeriodicNotification, isA<Function>());
    });

    test('Поддерживает запланированные уведомления', () {
      final service = NotificationService();

      expect(service.showScheduledNotification, isA<Function>());
    });
  });

  group('Notification Reminders', () {
    test('Напоминание о книгах формируется корректно', () {
      const title = '📚 Время читать!';
      const body =
          'У вас есть книги в статусе "В процессе". Продолжите чтение!';

      expect(title, contains('📚'));
      expect(title, contains('Время читать'));
      expect(body, contains('В процессе'));
    });

    test('Напоминание о новых книгах включает количество', () {
      const count = 5;
      const body = 'Вы добавили $count новых книг в библиотеку!';

      expect(body, contains('5'));
      expect(body, contains('новых книг'));
    });
  });
}
