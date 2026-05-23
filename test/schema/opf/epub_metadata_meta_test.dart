library epubreadertest;

import 'package:epubx/src/schema/opf/epub_metadata_meta.dart';
import 'package:test/test.dart';

main() async {
  var reference = EpubMetadataMeta(
    content: "some content",
    name: "Orthros",
    property: "Prop",
    refines: "Oil",
    id: "Unique",
    scheme: "A plot",
  );

  late EpubMetadataMeta testMetadataMeta;
  setUp(() async {
    testMetadataMeta = EpubMetadataMeta(
      content: reference.content,
      name: reference.name,
      property: reference.property,
      refines: reference.refines,
      id: reference.id,
      scheme: reference.scheme,
    );
  });

  group("EpubMetadataMeta", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testMetadataMeta, equals(reference));
      });

      test("is false when Refines changes", () async {
        testMetadataMeta = testMetadataMeta.copyWith(refines: "Natural gas");
        expect(testMetadataMeta, isNot(reference));
      });
      test("is false when Property changes", () async {
        testMetadataMeta =
            testMetadataMeta.copyWith(property: "A different Property");
        expect(testMetadataMeta, isNot(reference));
      });
      test("is false when Name changes", () async {
        testMetadataMeta = testMetadataMeta.copyWith(id: "notOrthros");
        expect(testMetadataMeta, isNot(reference));
      });
      test("is false when Content changes", () async {
        testMetadataMeta =
            testMetadataMeta.copyWith(content: "A different Content");
        expect(testMetadataMeta, isNot(reference));
      });
      test("is false when Id changes", () async {
        testMetadataMeta = testMetadataMeta.copyWith(id: "A different ID");
        expect(testMetadataMeta, isNot(reference));
      });
      test("is false when Scheme changes", () async {
        testMetadataMeta =
            testMetadataMeta.copyWith(scheme: "A strange scheme");
        expect(testMetadataMeta, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testMetadataMeta.hashCode, equals(reference.hashCode));
      });
      test("is false when Refines changes", () async {
        testMetadataMeta = testMetadataMeta.copyWith(refines: "Natural Gas");
        expect(testMetadataMeta.hashCode, isNot(reference.hashCode));
      });
      test("is false when Property changes", () async {
        testMetadataMeta =
            testMetadataMeta.copyWith(property: "A different property");
        expect(testMetadataMeta.hashCode, isNot(reference.hashCode));
      });
      test("is false when Name changes", () async {
        testMetadataMeta = testMetadataMeta.copyWith(name: "NotOrthros");
        expect(testMetadataMeta.hashCode, isNot(reference.hashCode));
      });
      test("is false when Content changes", () async {
        testMetadataMeta =
            testMetadataMeta.copyWith(content: "Different Content");
        expect(testMetadataMeta.hashCode, isNot(reference.hashCode));
      });
      test("is false when Id changes", () async {
        testMetadataMeta = testMetadataMeta.copyWith(id: "A different Id");
        expect(testMetadataMeta.hashCode, isNot(reference.hashCode));
      });
      test("is false when Scheme changes", () async {
        testMetadataMeta =
            testMetadataMeta.copyWith(scheme: "A strange scheme");
        expect(testMetadataMeta.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
