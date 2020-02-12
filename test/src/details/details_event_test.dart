import 'package:flutter_bloc_patterns/src/details/details_events.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('two load details events with the same id should be equal', () {
    const firstEvent = LoadDetails<int>(1);
    const secondEvent = LoadDetails<int>(1);

    expect(firstEvent, equals(secondEvent));
  });

  test('two load details events with the different ids should NOT be equal',
      () {
    const firstEvent = LoadDetails<int>(1);
    const secondEvent = LoadDetails<int>(2);

    expect(firstEvent, isNot(equals(secondEvent)));
  });

  test('toString should contain runtime type and id value', () {
    const event = LoadDetails<int>(1);

    expect(event.toString(), 'LoadDetails<int>: 1');
  });
}
