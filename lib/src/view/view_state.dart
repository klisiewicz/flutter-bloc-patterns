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
/// initial loading ends with [Success] or [Empty] result. It may contain
/// the data that has already been loaded.
final class Refreshing<T> extends ViewState<T> {
  final T data;

  const Refreshing(this.data);

  @override
  List<Object?> get props => [data];

  @override
  String toString() => 'Refreshing: $data';
}

/// State indicating that data was loaded successfully, but was null or empty.
final class Empty<T> extends ViewState<T> {
  const Empty();

  @override
  String toString() => 'Empty';
}

/// State indicating that data was loaded successfully and is not null nor empty.
/// [T] - list element type.
final class Success<T> extends ViewState<T> {
  final T data;

  const Success(this.data) : assert(data != null);

  @override
  List<Object?> get props => [data];

  @override
  String toString() => 'Success: $data';
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
