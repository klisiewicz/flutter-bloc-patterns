import 'package:flutter_bloc_patterns/paged_filter_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'should throw $AssertionError when creating paged list with no items and has NOT reached max ',
      () {
    expect(
      // ignore: avoid_redundant_argument_values
      () => PagedList(const [], hasReachedMax: false),
      throwsAssertionError,
    );
  });

  test(
      'should return normally when creating paged list with no items and has reached max',
      () {
    expect(
      () => PagedList(const [], hasReachedMax: true),
      returnsNormally,
    );
  });

  test(
      'should return normally when creating paged list with items and has reached max',
      () {
    expect(
      () => PagedList(const [1], hasReachedMax: true),
      returnsNormally,
    );
  });

  test(
      'should return normally when creating paged list with items and has NOT reached max',
      () {
    expect(
      // ignore: avoid_redundant_argument_values
      () => PagedList(const [1], hasReachedMax: false),
      returnsNormally,
    );
  });
}
