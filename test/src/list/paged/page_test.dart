import 'package:flutter_bloc_patterns/page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const size = 20;

  test('should create page with number and size', () {
    const page = Page(number: 1, size: size);
    expect(page.number, 1);
    expect(page.size, size);
  });

  test('should create first page with given size', () {
    const firstPage = Page.first(size: size);
    expect(firstPage.number, 0);
    expect(firstPage.size, size);
  });

  test('should return offset', () {
    const thirdPage = Page(number: 2, size: size);
    expect(thirdPage.offset, 2 * size);
  });

  test('should return next page', () {
    const firstPage = Page.first(size: size);
    final secondPage = firstPage.next();
    expect(secondPage.number, 1);
    expect(secondPage.size, size);
  });

  test('should return previous page', () {
    const secondPage = Page(number: 1, size: size);
    final firstPage = secondPage.previous();
    expect(firstPage.number, 0);
    expect(firstPage.size, size);
  });

  test('should not return previous page for the first page', () {
    const firstPage = Page.first(size: size);
    final previousPage = firstPage.previous();
    expect(previousPage.number, 0);
    expect(previousPage.size, size);
  });

  test('should be equal when page number and size are the same', () {
    const page = Page(number: 1, size: size);
    const samePage = Page(number: 1, size: size);
    expect(page == samePage, isTrue);
  });

  test('should return page size and number when calling toString', () {
    const firstPage = Page.first(size: size);
    expect(
      firstPage.toString(),
      '${firstPage.runtimeType} (number: 0, size: $size)',
    );
  });
}
