import 'package:flutter_bloc_patterns/src/list/base/list_events.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('load list events', () {
    test('two load list events with the same filter should be equal', () {
      const firstEvent = LoadList<int>(1);
      const secondEvent = LoadList<int>(1);
      expect(firstEvent, equals(secondEvent));
    });

    test('two load list events with the different filter should NOT be equal',
        () {
      const firstEvent = LoadList<int>(1);
      const secondEvent = LoadList<int>(2);
      expect(firstEvent, isNot(equals(secondEvent)));
    });

    test('toString should contain LoadList and filter value', () {
      const event = LoadList<int>(1);
      expect(event.toString(), 'LoadList: 1');
    });
  });

  group('refresh list events', () {
    test('two refresh list events with the same filter should be equal', () {
      const firstEvent = RefreshList<int>(1);
      const secondEvent = RefreshList<int>(1);
      expect(firstEvent, equals(secondEvent));
    });

    test(
        'two refresh list events with the different filter should NOT be equal',
        () {
      const firstEvent = RefreshList<int>(1);
      const secondEvent = RefreshList<int>(2);
      expect(firstEvent, isNot(equals(secondEvent)));
    });

    test('toString should contain RefreshList and filter value', () {
      const event = RefreshList<int>(1);
      expect(event.toString(), 'RefreshList: 1');
    });
  });
}
