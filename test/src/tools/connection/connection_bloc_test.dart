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
      'should be initialized in $online state '
      'and emit NO values '
      'when ConnectionRepository emits NO values ', () async {
    when(connectionRepository.observe).thenAnswerStreamValues([]);
    connection = ConnectionBloc(connectionRepository);
    expect(connection.state, equals(Connection.online));
    await withBloc(connection).expectStates([]);
  });

  test(
      'should emit all values '
      'when ConnectionRepository emits distinct values ', () async {
    final connections = [offline, online, offline];
    when(connectionRepository.observe).thenAnswerStreamValues(connections);
    connection = ConnectionBloc(connectionRepository);
    await withBloc(connection).expectStates(connections);
  });

  test(
      'should emit only distinct values '
      'when ConnectionRepository emits indistinct values ', () async {
    when(connectionRepository.observe)
        .thenAnswerStreamValues([offline, offline, online]);
    connection = ConnectionBloc(connectionRepository);
    await withBloc(connection).expectStates([offline, online]);
  });

  test(
      'should NOT emit any more values '
      'when closing bloc ', () async {
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
