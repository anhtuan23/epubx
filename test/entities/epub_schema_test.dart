library;

import 'package:epubx/epubx.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var reference = EpubSchema(
    package: EpubPackage(),
    navigation: EpubNavigation(),
    contentDirectoryPath: "some/random/path",
  );

  late EpubSchema testSchema;
  setUp(() async {
    testSchema = EpubSchema(
      package: EpubPackage(),
      navigation: EpubNavigation(),
      contentDirectoryPath: "some/random/path",
    );
  });

  group("EpubSchema", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testSchema, equals(reference));
      });

      test("is false when Package changes", () async {
        // Create a different package instance
        var package = EpubPackage(
          uniqueIdentifier: 'some/other/random/path/to/dev/null',
        );

        testSchema = EpubSchema(
          package: package,
          navigation: testSchema.navigation,
          contentDirectoryPath: testSchema.contentDirectoryPath,
        );
        expect(testSchema, isNot(reference));
      });

      test("is false when Navigation changes", () async {
        // Create a different navigation instance
        var navigation = EpubNavigation(
          fileName: 'some/other/random/path/to/dev/null',
        );

        testSchema = EpubSchema(
          package: testSchema.package,
          navigation: navigation,
          contentDirectoryPath: testSchema.contentDirectoryPath,
        );
        expect(testSchema, isNot(reference));
      });

      test("is false when ContentDirectoryPath changes", () async {
        testSchema = EpubSchema(
          package: testSchema.package,
          navigation: testSchema.navigation,
          contentDirectoryPath: "some/other/random/path/to/dev/null",
        );
        expect(testSchema, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testSchema.hashCode, equals(reference.hashCode));
      });

      test("is false when Package changes", () async {
        // Create a different package instance
        var package = EpubPackage(
          uniqueIdentifier: 'random/path/to/dev/null',
        );

        testSchema = EpubSchema(
          package: package,
          navigation: testSchema.navigation,
          contentDirectoryPath: testSchema.contentDirectoryPath,
        );
        expect(testSchema.hashCode, isNot(reference.hashCode));
      });

      test("is false when Navigation changes", () async {
        // Create a different navigation instance
        var navigation = EpubNavigation(
          fileName: 'random/path/to/dev/null',
        );

        testSchema = EpubSchema(
          package: testSchema.package,
          navigation: navigation,
          contentDirectoryPath: testSchema.contentDirectoryPath,
        );
        expect(testSchema.hashCode, isNot(reference.hashCode));
      });

      test("is false when ContentDirectoryPath changes", () async {
        testSchema = EpubSchema(
          package: testSchema.package,
          navigation: testSchema.navigation,
          contentDirectoryPath: "some/other/random/path/to/dev/null",
        );
        expect(testSchema.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
