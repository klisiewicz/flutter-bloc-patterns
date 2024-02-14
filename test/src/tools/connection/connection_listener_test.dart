import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_patterns/connection.dart';
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
        onOnline: onOnline.call,
        onOffline: onOffline.call,
        child: const SizedBox(),
      ),
    );
  }

  testWidgets(
    'should NOT invoke any callbacks when ConnectionBloc does not change state ',
    (tester) async {
      whenListen<Connection>(connection, noChanges, initialState: online);
      await tester.pumpWidget(makeTestableConnectionListener());

      onOnline.verifyNotCalled();
      onOffline.verifyNotCalled();
    },
  );

  testWidgets(
    'should invoke onOffline callback when ConnectionBloc moves from $online to $offline state',
    (tester) async {
      whenListen<Connection>(
        connection,
        Stream.value(offline),
        initialState: online,
      );
      await tester.pumpWidget(makeTestableConnectionListener());

      onOnline.verifyNotCalled();
      onOffline.verifyCalled();
    },
  );

  testWidgets(
    'should NOT invoke any callbacks when ConnectionBloc moves from $online to $online state ',
    (tester) async {
      whenListen<Connection>(
        connection,
        Stream.value(online),
        initialState: online,
      );
      await tester.pumpWidget(makeTestableConnectionListener());

      onOnline.verifyNotCalled();
      onOffline.verifyNotCalled();
    },
  );

  testWidgets(
    'should invoke onOffline and onOnline callbacks when ConnectionBloc emits $online, $offline, $online states',
    (tester) async {
      whenListen<Connection>(
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
