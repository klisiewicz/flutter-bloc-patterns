import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_patterns/src/tools/connection/connection_bloc.dart';
import 'package:flutter_bloc_patterns/src/tools/connection/connection_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/view_test_util.dart';
import 'connection_bloc_mock.dart';
import 'connection_test_data.dart';

void main() {
  late ConnectionCubitMock connection;

  setUp(() {
    connection = ConnectionCubitMock();
  });

  testWidgets(
      'GIVEN $ConnectionBloc in $online state '
      'WHEN pumping $ConnectionBuilder '
      'THEN should display online widget', (WidgetTester tester) async {
    whenListen(connection, noChanges, initialState: online);
    await tester.pumpConnectionBuilder(connection);
    verifyOnlineWidgetIsDisplayed();
  });

  testWidgets(
      'GIVEN $ConnectionBloc in $online state '
      'AND then in $offline state '
      'WHEN pumping $ConnectionBuilder '
      'THEN should display online widget '
      'AND offline widget afterwards', (WidgetTester tester) async {
    whenListen(connection, Stream.value(offline), initialState: online);
    await tester.pumpConnectionBuilder(connection);
    verifyOnlineWidgetIsDisplayed();
    await tester.pump();
    verifyOfflineWidgetIsDisplayed();
  });

  tearDown(() {
    connection.close();
  });
}

extension on WidgetTester {
  Future<void> pumpConnectionBuilder(ConnectionCubitMock bloc) async {
    await pumpWidget(
      makeTestableWidget(
        child: ConnectionBuilder(
          bloc: bloc,
          onOnline: (context) => const Text('Online'),
          onOffline: (context) => const Text('Offline'),
        ),
      ),
    );
  }
}

void verifyOnlineWidgetIsDisplayed() {
  expect(find.text('Online'), findsOneWidget);
}

void verifyOfflineWidgetIsDisplayed() {
  expect(find.text('Offline'), findsOneWidget);
}
