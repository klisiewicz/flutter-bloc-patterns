import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;

  User(this.id)
      : assert(id != null),
        super([id]);
}
