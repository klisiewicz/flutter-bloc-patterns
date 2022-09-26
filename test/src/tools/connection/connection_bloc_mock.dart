import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_patterns/src/tools/connection/connection.dart';
import 'package:flutter_bloc_patterns/src/tools/connection/connection_bloc.dart';

class ConnectionCubitMock extends MockCubit<Connection>
    implements ConnectionBloc {}
