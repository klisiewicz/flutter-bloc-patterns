import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;

  const User(this.id) : assert(id != null);

  @override
  List<Object> get props => [id];
}
