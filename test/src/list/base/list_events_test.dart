import 'package:flutter_bloc_patterns/src/list/base/list_events.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('load list events', () {
    test('two load list events with the same filter should be equal', () {
      final firstEvent = LoadList<int>(1);
      final secondEvent = LoadList<int>(1);

      expect(firstEvent, equals(secondEvent));
    });

    test('two load list events with the different filter should NOT be equal',
        () {
      final firstEvent = LoadList<int>(1);
      final secondEvent = LoadList<int>(2);

      expect(firstEvent, isNot(equals(secondEvent)));
    });

    test('toString should contain runtime type and filter value', () {
      final event = LoadList<int>(1);

      expect(event.toString(), 'LoadList<int>: 1');
    });
  });

  group('refresh list events', () {
    test('two refresh list events with the same filter should be equal', () {
      final firstEvent = RefreshList<int>(1);
      final secondEvent = RefreshList<int>(1);

      expect(firstEvent, equals(secondEvent));
    });

    test('two refresh list events with the different filter should NOT be equal',
        () {
      final firstEvent = RefreshList<int>(1);
      final secondEvent = RefreshList<int>(2);

      expect(firstEvent, isNot(equals(secondEvent)));
    });

    test('toString should contain runtime type and filter value', () {
      final event = RefreshList<int>(1);

      expect(event.toString(), 'RefreshList<int>: 1');
    });
  });
}
