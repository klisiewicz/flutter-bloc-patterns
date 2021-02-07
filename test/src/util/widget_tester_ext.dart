import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExt on WidgetTester {
  Future<void> asyncPump() {
    return runAsync(() async {
      await idle();
      await pump(Duration.zero);
    });
  }
}
