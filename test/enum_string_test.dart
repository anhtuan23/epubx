library;

import 'package:test/test.dart';

import 'package:epubx/epubx.dart';

void main() {
  test("Enum One", () {
    expect(
        EnumFromString<Simple>(Simple.values).get("ONE"), equals(Simple.ONE));
  });
  test("Enum Two", () {
    expect(
        EnumFromString<Simple>(Simple.values).get("TWO"), equals(Simple.TWO));
  });
  test("Enum One", () {
    expect(EnumFromString<Simple>(Simple.values).get("THREE"),
        equals(Simple.THREE));
  });
  test("Enum One Lower Case", () {
    expect(
        EnumFromString<Simple>(Simple.values).get("one"), equals(Simple.ONE));
  });
}

enum Simple { ONE, TWO, THREE }
