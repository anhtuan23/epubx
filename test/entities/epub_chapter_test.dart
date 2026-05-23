library;

import 'package:epubx/epubx.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var reference = EpubChapter(
    anchor: "anchor",
    contentFileName: "orthros",
    htmlContent: "<html></html>",
    subChapters: [],
    title: "A New Look at Chapters",
  );

  late EpubChapter testChapter;
  setUp(() async {
    testChapter = EpubChapter(
      anchor: "anchor",
      contentFileName: "orthros",
      htmlContent: "<html></html>",
      subChapters: [],
      title: "A New Look at Chapters",
    );
  });

  group("EpubChapter", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testChapter, equals(reference));
      });

      test("is false when HtmlContent changes", () async {
        testChapter = EpubChapter(
          anchor: testChapter.anchor,
          contentFileName: testChapter.contentFileName,
          htmlContent: "<html>I'm sure this isn't valid Html</html>",
          subChapters: testChapter.subChapters,
          title: testChapter.title,
        );
        expect(testChapter, isNot(reference));
      });

      test("is false when Anchor changes", () async {
        testChapter = EpubChapter(
          anchor: "NotAnAnchor",
          contentFileName: testChapter.contentFileName,
          htmlContent: testChapter.htmlContent,
          subChapters: testChapter.subChapters,
          title: testChapter.title,
        );
        expect(testChapter, isNot(reference));
      });

      test("is false when ContentFileName changes", () async {
        testChapter = EpubChapter(
          anchor: testChapter.anchor,
          contentFileName: "NotOrthros",
          htmlContent: testChapter.htmlContent,
          subChapters: testChapter.subChapters,
          title: testChapter.title,
        );
        expect(testChapter, isNot(reference));
      });

      test("is false when SubChapters changes", () async {
        var chapter = EpubChapter(
          title: "A Brave new Epub",
          contentFileName: "orthros.txt",
        );

        testChapter = EpubChapter(
          anchor: testChapter.anchor,
          contentFileName: testChapter.contentFileName,
          htmlContent: testChapter.htmlContent,
          subChapters: [chapter],
          title: testChapter.title,
        );
        expect(testChapter, isNot(reference));
      });

      test("is false when Title changes", () async {
        testChapter = EpubChapter(
          anchor: testChapter.anchor,
          contentFileName: testChapter.contentFileName,
          htmlContent: testChapter.htmlContent,
          subChapters: testChapter.subChapters,
          title: "A Boring Old World",
        );
        expect(testChapter, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testChapter.hashCode, equals(reference.hashCode));
      });

      test("is false when HtmlContent changes", () async {
        testChapter = EpubChapter(
          anchor: testChapter.anchor,
          contentFileName: testChapter.contentFileName,
          htmlContent: "<html>I'm sure this isn't valid Html</html>",
          subChapters: testChapter.subChapters,
          title: testChapter.title,
        );
        expect(testChapter.hashCode, isNot(reference.hashCode));
      });

      test("is false when Anchor changes", () async {
        testChapter = EpubChapter(
          anchor: "NotAnAnchor",
          contentFileName: testChapter.contentFileName,
          htmlContent: testChapter.htmlContent,
          subChapters: testChapter.subChapters,
          title: testChapter.title,
        );
        expect(testChapter.hashCode, isNot(reference.hashCode));
      });

      test("is false when ContentFileName changes", () async {
        testChapter = EpubChapter(
          anchor: testChapter.anchor,
          contentFileName: "NotOrthros",
          htmlContent: testChapter.htmlContent,
          subChapters: testChapter.subChapters,
          title: testChapter.title,
        );
        expect(testChapter.hashCode, isNot(reference.hashCode));
      });

      test("is false when SubChapters changes", () async {
        var chapter = EpubChapter(
          title: "A Brave new Epub",
          contentFileName: "orthros.txt",
        );

        testChapter = EpubChapter(
          anchor: testChapter.anchor,
          contentFileName: testChapter.contentFileName,
          htmlContent: testChapter.htmlContent,
          subChapters: [chapter],
          title: testChapter.title,
        );
        expect(testChapter.hashCode, isNot(reference.hashCode));
      });

      test("is false when Title changes", () async {
        testChapter = EpubChapter(
          anchor: testChapter.anchor,
          contentFileName: testChapter.contentFileName,
          htmlContent: testChapter.htmlContent,
          subChapters: testChapter.subChapters,
          title: "A Boring Old World",
        );
        expect(testChapter.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
