library epubreadertest;

import 'package:epubx/epubx.dart';
import 'package:test/test.dart';

main() async {
  final Image defaultImage = Image(width: 100, height: 100);
  final chapters = [EpubChapter()];
  final content = EpubContent();
  final schema = EpubSchema();

  var reference = EpubBook(
    author: "orthros",
    authorList: ["orthros"],
    chapters: chapters,
    content: content,
    coverImage: defaultImage,
    schema: schema,
    title: "A Dissertation on Epubs",
  );

  late EpubBook testBook;
  setUp(() async {
    testBook = EpubBook(
      author: "orthros",
      authorList: ["orthros"],
      chapters: chapters,
      content: content,
      coverImage: defaultImage,
      schema: schema,
      title: "A Dissertation on Epubs",
    );
  });

  group("EpubBook", () {
    group(".equals", () {
      test("is true for equivalent objects", () async {
        expect(testBook, equals(reference));
      });

      test("is false when Content changes", () async {
        var file = EpubTextContentFile(
          content: "Hello",
          contentMimeType: "application/txt",
          contentType: EpubContentType.OTHER,
          fileName: "orthros.txt",
        );

        var newContentFiles = <String, EpubContentFile>{"hello": file};
        var newContent = EpubContent(allFiles: newContentFiles);

        testBook = EpubBook(
          author: testBook.author,
          authorList: testBook.authorList,
          chapters: testBook.chapters,
          content: newContent,
          coverImage: testBook.coverImage,
          schema: testBook.schema,
          title: testBook.title,
        );

        expect(testBook, isNot(reference));
      });

      test("is false when Author changes", () async {
        testBook = EpubBook(
          author: "NotOrthros",
          authorList: testBook.authorList,
          chapters: testBook.chapters,
          content: testBook.content,
          coverImage: testBook.coverImage,
          schema: testBook.schema,
          title: testBook.title,
        );
        expect(testBook, isNot(reference));
      });

      test("is false when AuthorList changes", () async {
        testBook = EpubBook(
          author: testBook.author,
          authorList: ["NotOrthros"],
          chapters: testBook.chapters,
          content: testBook.content,
          coverImage: testBook.coverImage,
          schema: testBook.schema,
          title: testBook.title,
        );
        expect(testBook, isNot(reference));
      });

      test("is false when Chapters changes", () async {
        var chapter = EpubChapter(
          title: "A Brave new Epub",
          contentFileName: "orthros.txt",
        );

        testBook = EpubBook(
          author: testBook.author,
          authorList: testBook.authorList,
          chapters: [chapter],
          content: testBook.content,
          coverImage: testBook.coverImage,
          schema: testBook.schema,
          title: testBook.title,
        );
        expect(testBook, isNot(reference));
      });

      test("is false when CoverImage changes", () async {
        testBook = EpubBook(
          author: testBook.author,
          authorList: testBook.authorList,
          chapters: testBook.chapters,
          content: testBook.content,
          coverImage: Image(width: 200, height: 200),
          schema: testBook.schema,
          title: testBook.title,
        );
        expect(testBook, isNot(reference));
      });

      test("is false when Schema changes", () async {
        var newSchema = EpubSchema(contentDirectoryPath: "some/random/path");

        testBook = EpubBook(
          author: testBook.author,
          authorList: testBook.authorList,
          chapters: testBook.chapters,
          content: testBook.content,
          coverImage: testBook.coverImage,
          schema: newSchema,
          title: testBook.title,
        );
        expect(testBook, isNot(reference));
      });

      test("is false when Title changes", () async {
        testBook = EpubBook(
          author: testBook.author,
          authorList: testBook.authorList,
          chapters: testBook.chapters,
          content: testBook.content,
          coverImage: testBook.coverImage,
          schema: testBook.schema,
          title: "The Philosophy of Epubs",
        );
        expect(testBook, isNot(reference));
      });
    });

    group(".hashCode", () {
      test("is true for equivalent objects", () async {
        expect(testBook.hashCode, equals(reference.hashCode));
      });

      test("is false when Content changes", () async {
        var file = EpubTextContentFile(
          content: "Hello",
          contentMimeType: "application/txt",
          contentType: EpubContentType.OTHER,
          fileName: "orthros.txt",
        );

        var newContentFiles = <String, EpubContentFile>{"hello": file};
        var newContent = EpubContent(allFiles: newContentFiles);

        testBook = EpubBook(
          author: testBook.author,
          authorList: testBook.authorList,
          chapters: testBook.chapters,
          content: newContent,
          coverImage: testBook.coverImage,
          schema: testBook.schema,
          title: testBook.title,
        );

        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Author changes", () async {
        testBook = EpubBook(
          author: "NotOrthros",
          authorList: testBook.authorList,
          chapters: testBook.chapters,
          content: testBook.content,
          coverImage: testBook.coverImage,
          schema: testBook.schema,
          title: testBook.title,
        );
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when AuthorList changes", () async {
        testBook = EpubBook(
          author: testBook.author,
          authorList: ["NotOrthros"],
          chapters: testBook.chapters,
          content: testBook.content,
          coverImage: testBook.coverImage,
          schema: testBook.schema,
          title: testBook.title,
        );
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Chapters changes", () async {
        var chapter = EpubChapter(
          title: "A Brave new Epub",
          contentFileName: "orthros.txt",
        );

        testBook = EpubBook(
          author: testBook.author,
          authorList: testBook.authorList,
          chapters: [chapter],
          content: testBook.content,
          coverImage: testBook.coverImage,
          schema: testBook.schema,
          title: testBook.title,
        );
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when CoverImage changes", () async {
        testBook = EpubBook(
          author: testBook.author,
          authorList: testBook.authorList,
          chapters: testBook.chapters,
          content: testBook.content,
          coverImage: Image(width: 200, height: 200),
          schema: testBook.schema,
          title: testBook.title,
        );
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Schema changes", () async {
        var newSchema = EpubSchema(contentDirectoryPath: "some/random/path");

        testBook = EpubBook(
          author: testBook.author,
          authorList: testBook.authorList,
          chapters: testBook.chapters,
          content: testBook.content,
          coverImage: testBook.coverImage,
          schema: newSchema,
          title: testBook.title,
        );
        expect(testBook.hashCode, isNot(reference.hashCode));
      });

      test("is false when Title changes", () async {
        testBook = EpubBook(
          author: testBook.author,
          authorList: testBook.authorList,
          chapters: testBook.chapters,
          content: testBook.content,
          coverImage: testBook.coverImage,
          schema: testBook.schema,
          title: "The Philosophy of Epubs",
        );
        expect(testBook.hashCode, isNot(reference.hashCode));
      });
    });
  });
}
