import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_patterns/src/tools/connection/connection_bloc.dart';
import 'package:flutter_bloc_patterns/src/tools/connection/connection_listener.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../util/view_test_util.dart';
import '../../view/view_state_fakes.dart';
import 'connection_bloc_mock.dart';
import 'connection_test_data.dart';

class ConnectionMock extends Mock {
  void call(BuildContext context);
}

void main() {
  late ConnectionCubitMock connection;
  late ConnectionMock onOnline;
  late ConnectionMock onOffline;

  setUpAll(() {
    registerBuildContextFallbackValue();
  });

  setUp(() {
    connection = ConnectionCubitMock();
    onOnline = ConnectionMock();
    onOffline = ConnectionMock();
  });

  Widget makeTestableConnectionListener() {
    return makeTestableWidget(
      child: ConnectionListener(
        bloc: connection,
        onOnline: onOnline,
        onOffline: onOffline,
        child: const SizedBox(),
      ),
    );
  }

  testWidgets(
    'GIVEN $ConnectionBloc without any state changes '
    'WHEN pumping $ConnectionListener '
    'THEN should NOT invoke any callbacks',
    (WidgetTester tester) async {
      whenListen(connection, noChanges, initialState: online);
      await tester.pumpWidget(makeTestableConnectionListener());
      onOnline.verifyNotCalled();
      onOffline.verifyNotCalled();
    },
  );

  testWidgets(
    'GIVEN $ConnectionBloc emitting $offline state '
    'WHEN pumping $ConnectionListener '
    'THEN should invoke onOffline callback',
    (WidgetTester tester) async {
      whenListen(connection, Stream.value(offline), initialState: online);
      await tester.pumpWidget(makeTestableConnectionListener());
      onOnline.verifyNotCalled();
      onOffline.verifyCalled();
    },
  );

  testWidgets(
    'GIVEN $ConnectionBloc emitting $online state '
    'WHEN pumping $ConnectionListener '
    'THEN should NOT invoke any callbacks',
    (WidgetTester tester) async {
      whenListen(connection, Stream.value(online), initialState: online);
      await tester.pumpWidget(makeTestableConnectionListener());
      onOnline.verifyNotCalled();
      onOffline.verifyNotCalled();
    },
  );

  testWidgets(
    'GIVEN $ConnectionBloc emitting $offline '
    'AND then $online '
    'WHEN pumping $ConnectionListener '
    'THEN should invoke onOffline and onOnline callbacks',
    (WidgetTester tester) async {
      whenListen(
        connection,
        Stream.fromIterable([offline, online]),
        initialState: online,
      );
      await tester.pumpWidget(makeTestableConnectionListener());
      onOnline.verifyCalled();
      onOffline.verifyCalled();
    },
  );

  tearDown(() {
    connection.close();
  });
}

extension on ConnectionMock {
  void verifyCalled() => verify(() => call(any()));

  void verifyNotCalled() => verifyNever(() => call(any()));
}
