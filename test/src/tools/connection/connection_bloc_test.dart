import 'package:flutter_bloc_patterns/src/tools/connection/connection.dart';
import 'package:flutter_bloc_patterns/src/tools/connection/connection_bloc.dart';
import 'package:flutter_bloc_patterns/src/tools/connection/connection_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../util/bloc_state_assertion.dart';
import '../../util/mocktail_ext.dart';
import 'connection_test_data.dart';

class ConnectionRepositoryMock extends Mock implements ConnectionRepository {}

void main() {
  late ConnectionRepository connectionRepository;
  late ConnectionBloc connection;

  setUp(() {
    connectionRepository = ConnectionRepositoryMock();
  });

  test(
      'WHEN $ConnectionRepository emits NO values '
      'THEN $ConnectionBloc should be initialized in $online state '
      'AND should NOT emit NO values', () async {
    when(connectionRepository.observe).thenAnswerStreamValues([]);
    connection = ConnectionBloc(connectionRepository);
    expect(connection.state, equals(Connection.online));
    await withBloc(connection).expectStates([]);
  });

  test(
      'WHEN $ConnectionRepository emits distinct values '
      'THEN $ConnectionBloc should emit all values', () async {
    final connections = [offline, online, offline];
    when(connectionRepository.observe).thenAnswerStreamValues(connections);
    connection = ConnectionBloc(connectionRepository);
    await withBloc(connection).expectStates(connections);
  });

  test(
      'WHEN $ConnectionRepository emits indistinct values '
      'THEN $ConnectionBloc should emit only distinct values', () async {
    when(connectionRepository.observe)
        .thenAnswerStreamValues([offline, offline, online]);
    connection = ConnectionBloc(connectionRepository);
    await withBloc(connection).expectStates([offline, online]);
  });

  test(
      'WHEN closing $ConnectionBloc '
      'THEN should NOT emit any more values', () async {
    final connections = [offline, online, offline, online];
    const emitDelay = Duration(milliseconds: 50);
    when(connectionRepository.observe)
        .thenAnswerStreamDelayedValues(connections, delay: emitDelay);
    connection = ConnectionBloc(connectionRepository);
    connection.closeAfter(const Duration(milliseconds: 110));
    await withBloc(connection).expectStates(connections.take(2));
  });
}

extension on ConnectionBloc {
  void closeAfter(Duration delay) {
    Future.delayed(delay, close);
  }
}
