import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Base class for states.
@immutable
sealed class ViewState<T> with EquatableMixin {
  const ViewState();

  @override
  List<Object?> get props => [];
}

/// The initial view state.
final class Initial<T> extends ViewState<T> {
  const Initial();

  @override
  String toString() => 'Initial';
}

/// State indicating that data is being loaded.
final class Loading<T> extends ViewState<T> {
  const Loading();

  @override
  String toString() => 'Loading';
}

/// State indicating that data is being refreshed. It can occur only after
/// initial loading ends with [Data] or [Empty] result. It may contain
/// the data that has already been loaded.
final class Refreshing<T> extends ViewState<T> {
  final T value;

  const Refreshing(this.value);

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'Refreshing: $value';
}

/// State indicating that data was loaded successfully, but was null or empty.
final class Empty<T> extends ViewState<T> {
  const Empty();

  @override
  String toString() => 'Empty';
}

/// State indicating that data was loaded successfully and is not null nor empty.
/// [T] - list element type.
final class Data<T> extends ViewState<T> {
  final T value;

  const Data(this.value) : assert(value != null);

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'Data: $value';
}

/// State indicating that loading or refreshing has failed. It contains an
/// exact [error] that has occurred.
final class Failure<T> extends ViewState<T> {
  final Object error;

  const Failure(this.error);

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'Failure: $error';
}
