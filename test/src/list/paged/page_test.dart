import 'package:flutter_bloc_patterns/paged_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final size = 20;

  test('should create page with number and size', () {
    final page = Page(number: 1, size: size);

    expect(page.number, 1);
    expect(page.size, size);
  });

  test('should create first page with given size', () {
    final firstPage = Page.first(size: size);

    expect(firstPage.number, 0);
    expect(firstPage.size, size);
  });

  test('should return offset', () {
    final thirdPage = Page(number: 2, size: size);

    expect(thirdPage.offset, 2 * size);
  });

  test('should return next page', () {
    final firstPage = Page.first(size: size);
    final secondPage = firstPage.next();
    expect(secondPage.number, 1);
    expect(secondPage.size, size);
  });

  test('should return previous page', () {
    final secondPage = Page(number: 1, size: size);
    final firstPage = secondPage.previous();
    expect(firstPage.number, 0);
    expect(firstPage.size, size);
  });

  test('should not return previous page when', () {
    final firstPage = Page.first(size: size);
    final previousPage = firstPage.previous();
    expect(previousPage.number, 0);
    expect(previousPage.size, size);
  });
}