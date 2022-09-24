import 'package:mocktail/mocktail.dart';

extension WhenVoidExt on When<void> {
  void thenCompleteNormally() => thenAnswer((_) async {});

  void thenCompleteNormallyAfter({
    required Duration delay,
  }) {
    thenAnswer((_) async => Future.delayed(delay, () async {}));
  }
}

extension WhenStreamExt<T> on When<Stream<T>> {
  void thenAnswerStreamValue(T value) => thenAnswer((_) => Stream.value(value));

  void thenAnswerStreamValues(List<T> values) {
    thenAnswer((_) => Stream.fromIterable(values));
  }

  void thenAnswerStreamDelayedValues(
    List<T> values, {
    required Duration delay,
  }) {
    thenAnswer((_) {
      return Stream.periodic(delay, (index) => values[index])
          .take(values.length);
    });
  }

  void thenAnswerStreamDelayedValue(
    T value, {
    required Duration delay,
  }) {
    thenAnswer((_) => Stream.fromFuture(Future.delayed(delay, () => value)));
  }

  void thenAnswerStreamError(Object error, [StackTrace? stackTrace]) {
    thenAnswer((_) => Stream<T>.error(error, stackTrace));
  }
}

extension WhenFutureExt<T> on When<Future<T>> {
  void thenAnswerFutureValue(T value) => thenAnswer((_) async => value);

  void thenAnswerDelayedValue(T value, {required Duration delay}) {
    thenAnswer((_) async => Future.delayed(delay, () => value));
  }

  void thenAnswerError(Object error) => thenAnswer((_) async => throw error);

  void thenThrowDelayedError(Object error, {required Duration delay}) {
    thenAnswer((_) async => Future.delayed(delay, () => throw error));
  }
}
