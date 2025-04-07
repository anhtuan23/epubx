library epubreadertest;

import 'package:epubx/epubx.dart';
import 'package:test/test.dart';

main() async {
  var reference = EpubByteContentFile(
    content: [0, 1, 2, 3],
    contentMimeType: "application/test",
    contentType: EpubContentType.OTHER,
    fileName: "orthrosFile",
  );

  late EpubByteContentFile testFile;
  setUp(() async {
    testFile = EpubByteContentFile(
      content: [0, 1, 2, 3],
      contentMimeType: "application/test",
      contentType: EpubContentType.OTHER,
      fileName: "orthrosFile",
    );
  });

  group("EpubByteContentFile", () {
    test(".equals is true for equivalent objects", () async {
      expect(testFile, equals(reference));
    });

    test(".equals is false when Content changes", () async {
      testFile = EpubByteContentFile(
        content: [3, 2, 1, 0],
        contentMimeType: testFile.contentMimeType,
        contentType: testFile.contentType,
        fileName: testFile.fileName,
      );
      expect(testFile, isNot(reference));
    });

    test(".equals is false when ContentMimeType changes", () async {
      testFile = EpubByteContentFile(
        content: testFile.content,
        contentMimeType: "application/different",
        contentType: testFile.contentType,
        fileName: testFile.fileName,
      );
      expect(testFile, isNot(reference));
    });

    test(".equals is false when ContentType changes", () async {
      testFile = EpubByteContentFile(
        content: testFile.content,
        contentMimeType: testFile.contentMimeType,
        contentType: EpubContentType.CSS,
        fileName: testFile.fileName,
      );
      expect(testFile, isNot(reference));
    });

    test(".equals is false when FileName changes", () async {
      testFile = EpubByteContentFile(
        content: testFile.content,
        contentMimeType: testFile.contentMimeType,
        contentType: testFile.contentType,
        fileName: "a_different_file_name.txt",
      );
      expect(testFile, isNot(reference));
    });

    test(".hashCode is the same for equivalent content", () async {
      expect(testFile.hashCode, equals(reference.hashCode));
    });

    test('.hashCode changes when Content changes', () async {
      testFile = EpubByteContentFile(
        content: [3, 2, 1, 0],
        contentMimeType: testFile.contentMimeType,
        contentType: testFile.contentType,
        fileName: testFile.fileName,
      );
      expect(testFile.hashCode, isNot(reference.hashCode));
    });

    test('.hashCode changes when ContentMimeType changes', () async {
      testFile = EpubByteContentFile(
        content: testFile.content,
        contentMimeType: "application/orthros",
        contentType: testFile.contentType,
        fileName: testFile.fileName,
      );
      expect(testFile.hashCode, isNot(reference.hashCode));
    });

    test('.hashCode changes when ContentType changes', () async {
      testFile = EpubByteContentFile(
        content: testFile.content,
        contentMimeType: testFile.contentMimeType,
        contentType: EpubContentType.CSS,
        fileName: testFile.fileName,
      );
      expect(testFile.hashCode, isNot(reference.hashCode));
    });

    test('.hashCode changes when FileName changes', () async {
      testFile = EpubByteContentFile(
        content: testFile.content,
        contentMimeType: testFile.contentMimeType,
        contentType: testFile.contentType,
        fileName: "a_different_file_name",
      );
      expect(testFile.hashCode, isNot(reference.hashCode));
    });
  });
}
