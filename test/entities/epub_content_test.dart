library epubreadertest;

import 'package:epubx/epubx.dart';
import 'package:test/test.dart';

main() async {
  var reference = EpubContent();

  late EpubContent testContent;
  late EpubTextContentFile textContentFile;
  late EpubByteContentFile byteContentFile;
  setUp(() async {
    testContent = EpubContent();

    textContentFile = EpubTextContentFile(
      content: "Some string",
      contentMimeType: "application/text",
      contentType: EpubContentType.OTHER,
      fileName: "orthros.txt",
    );

    byteContentFile = EpubByteContentFile(
      content: [0, 1, 2, 3],
      contentMimeType: "application/orthros",
      contentType: EpubContentType.OTHER,
      fileName: "orthros.bin",
    );
  });

  group("EpubContent", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testContent, equals(reference));
      });

      test("is false when Html changes", () async {
        var modifiedHtml =
            Map<String, EpubTextContentFile>.from(testContent.html);
        modifiedHtml["someKey"] = textContentFile;

        testContent = EpubContent(
          html: modifiedHtml,
          css: testContent.css,
          images: testContent.images,
          fonts: testContent.fonts,
          allFiles: testContent.allFiles,
        );
        expect(testContent, isNot(reference));
      });

      test("is false when Css changes", () async {
        var modifiedCss =
            Map<String, EpubTextContentFile>.from(testContent.css);
        modifiedCss["someKey"] = textContentFile;

        testContent = EpubContent(
          html: testContent.html,
          css: modifiedCss,
          images: testContent.images,
          fonts: testContent.fonts,
          allFiles: testContent.allFiles,
        );
        expect(testContent, isNot(reference));
      });

      test("is false when Images changes", () async {
        var modifiedImages =
            Map<String, EpubByteContentFile>.from(testContent.images);
        modifiedImages["someKey"] = byteContentFile;

        testContent = EpubContent(
          html: testContent.html,
          css: testContent.css,
          images: modifiedImages,
          fonts: testContent.fonts,
          allFiles: testContent.allFiles,
        );
        expect(testContent, isNot(reference));
      });

      test("is false when Fonts changes", () async {
        var modifiedFonts =
            Map<String, EpubByteContentFile>.from(testContent.fonts);
        modifiedFonts["someKey"] = byteContentFile;

        testContent = EpubContent(
          html: testContent.html,
          css: testContent.css,
          images: testContent.images,
          fonts: modifiedFonts,
          allFiles: testContent.allFiles,
        );
        expect(testContent, isNot(reference));
      });

      test("is false when AllFiles changes", () async {
        var modifiedAllFiles =
            Map<String, EpubContentFile>.from(testContent.allFiles);
        modifiedAllFiles["someKey"] = byteContentFile;

        testContent = EpubContent(
          html: testContent.html,
          css: testContent.css,
          images: testContent.images,
          fonts: testContent.fonts,
          allFiles: modifiedAllFiles,
        );
        expect(testContent, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testContent.hashCode, equals(reference.hashCode));
      });

      test("is false when Html changes", () async {
        var modifiedHtml =
            Map<String, EpubTextContentFile>.from(testContent.html);
        modifiedHtml["someKey"] = textContentFile;

        testContent = EpubContent(
          html: modifiedHtml,
          css: testContent.css,
          images: testContent.images,
          fonts: testContent.fonts,
          allFiles: testContent.allFiles,
        );
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when Css changes", () async {
        var modifiedCss =
            Map<String, EpubTextContentFile>.from(testContent.css);
        modifiedCss["someKey"] = textContentFile;

        testContent = EpubContent(
          html: testContent.html,
          css: modifiedCss,
          images: testContent.images,
          fonts: testContent.fonts,
          allFiles: testContent.allFiles,
        );
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when Images changes", () async {
        var modifiedImages =
            Map<String, EpubByteContentFile>.from(testContent.images);
        modifiedImages["someKey"] = byteContentFile;

        testContent = EpubContent(
          html: testContent.html,
          css: testContent.css,
          images: modifiedImages,
          fonts: testContent.fonts,
          allFiles: testContent.allFiles,
        );
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when Fonts changes", () async {
        var modifiedFonts =
            Map<String, EpubByteContentFile>.from(testContent.fonts);
        modifiedFonts["someKey"] = byteContentFile;

        testContent = EpubContent(
          html: testContent.html,
          css: testContent.css,
          images: testContent.images,
          fonts: modifiedFonts,
          allFiles: testContent.allFiles,
        );
        expect(testContent.hashCode, isNot(reference.hashCode));
      });

      test("is false when AllFiles changes", () async {
        var modifiedAllFiles =
            Map<String, EpubContentFile>.from(testContent.allFiles);
        modifiedAllFiles["someKey"] = byteContentFile;

        testContent = EpubContent(
          html: testContent.html,
          css: testContent.css,
          images: testContent.images,
          fonts: testContent.fonts,
          allFiles: modifiedAllFiles,
        );
        expect(testContent.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
