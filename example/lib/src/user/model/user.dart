import 'package:equatable/equatable.dart';

class User with EquatableMixin {
  final String id;

  const User(this.id);

  @override
  List<Object> get props => [id];
}
