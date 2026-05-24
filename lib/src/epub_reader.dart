import 'dart:async';

import 'package:archive/archive.dart';

import 'entities/epub_book.dart';
import 'entities/epub_byte_content_file.dart';
import 'entities/epub_chapter.dart';
import 'entities/epub_content.dart';
import 'entities/epub_content_file.dart';
import 'entities/epub_text_content_file.dart';
import 'readers/content_reader.dart';
import 'readers/schema_reader.dart';
import 'ref_entities/epub_book_ref.dart';
import 'ref_entities/epub_byte_content_file_ref.dart';
import 'ref_entities/epub_chapter_ref.dart';
import 'ref_entities/epub_content_file_ref.dart';
import 'ref_entities/epub_content_ref.dart';
import 'ref_entities/epub_text_content_file_ref.dart';

/// A class that provides the primary interface to read Epub files.
///
/// To open an Epub and load all data at once use the [readBook()] method.
///
/// To open an Epub and load only basic metadata use the [openBook()] method.
/// This is a good option to quickly load text-based metadata, while leaving the
/// heavier lifting of loading images and main content for subsequent operations.
///
/// ## Example
/// ```dart
/// // Read the basic metadata.
/// EpubBookRef epub = await EpubReader.openBook(epubFileBytes);
/// // Extract values of interest.
/// String title = epub.Title;
/// String author = epub.Author;
/// var metadata = epub.Schema.Package.Metadata;
/// String genres = metadata.Subjects.join(', ');
/// ```
class EpubReader {
  /// Loads basics metadata.
  ///
  /// Opens the book asynchronously without reading its main content.
  /// Holds the handle to the EPUB file.
  ///
  /// Argument [bytes] should be the bytes of
  /// the epub file you have loaded with something like the [dart:io] package's
  /// [readAsBytes()].
  ///
  /// This is a fast and convenient way to get the most important information
  /// about the book, notably the [Title], [Author] and [AuthorList].
  /// Additional information is loaded in the [Schema] property such as the
  /// Epub version, Publishers, Languages and more.
  static Future<EpubBookRef> openBook(FutureOr<List<int>> bytes) async {
    List<int> loadedBytes;
    if (bytes is Future) {
      loadedBytes = await bytes;
    } else {
      loadedBytes = bytes;
    }

    var epubArchive = ZipDecoder().decodeBytes(loadedBytes);

    var bookRef = EpubBookRef(epubArchive);
    try {
      bookRef.schema = await SchemaReader.readSchema(epubArchive);

      // Add safe null handling for title
      if (bookRef.schema?.package?.metadata?.titles != null &&
          bookRef.schema!.package!.metadata!.titles!.isNotEmpty) {
        bookRef.title = bookRef.schema!.package!.metadata!.titles!.first;
      } else {
        bookRef.title = ''; // Default empty title
        print('Warning: No title found in EPUB metadata.');
      }

      // Add safe null handling for author list
      if (bookRef.schema?.package?.metadata?.creators != null) {
        bookRef.authorList = bookRef.schema!.package!.metadata!.creators!
            .map((creator) => creator.creator ?? '')
            .where((name) => name.isNotEmpty)
            .toList();
      } else {
        bookRef.authorList = <String>[];
        print('Warning: No authors found in EPUB metadata.');
      }

      bookRef.author = bookRef.authorList!.join(', ');
      bookRef.content = ContentReader.parseContentMap(bookRef);
    } on Exception catch (e) {
      print('Error parsing EPUB structure: $e');
      // Provide minimal valid structure to prevent null reference errors
      bookRef.schema ??= SchemaReader.createMinimalSchema();
      bookRef.title ??= '';
      bookRef.authorList ??= <String>[];
      bookRef.author ??= '';
      bookRef.content ??= ContentReader.createMinimalContentRef();
    }

    return bookRef;
  }

  /// Opens the book asynchronously and reads all of its content into the memory. Does not hold the handle to the EPUB file.
  static Future<EpubBook> readBook(FutureOr<List<int>> bytes) async {
    List<int> loadedBytes;
    if (bytes is Future) {
      loadedBytes = await bytes;
    } else {
      loadedBytes = bytes;
    }

    var epubBookRef = await openBook(loadedBytes);
    var content = await readContent(epubBookRef.content!);
    var coverImage = await epubBookRef.readCover();
    var chapterRefs = await epubBookRef.getChapters();
    var chapters = await readChapters(chapterRefs);

    return EpubBook(
      schema: epubBookRef.schema,
      title: epubBookRef.title,
      authorList: epubBookRef.authorList,
      author: epubBookRef.author,
      content: content,
      coverImage: coverImage,
      chapters: chapters,
    );
  }

  static Future<EpubContent> readContent(EpubContentRef contentRef) async {
    final html = await readTextContentFiles(contentRef.html);
    final css = await readTextContentFiles(contentRef.css);
    final images = await readByteContentFiles(contentRef.images);
    final fonts = await readByteContentFiles(contentRef.fonts);
    final allFiles = <String, EpubContentFile>{};

    // Add HTML files to allFiles
    html.forEach((String? key, EpubTextContentFile value) {
      allFiles[key!] = value;
    });

    // Add CSS files to allFiles
    css.forEach((String? key, EpubTextContentFile value) {
      allFiles[key!] = value;
    });

    // Add image files to allFiles
    images.forEach((String? key, EpubByteContentFile value) {
      allFiles[key!] = value;
    });

    // Add font files to allFiles
    fonts.forEach((String? key, EpubByteContentFile value) {
      allFiles[key!] = value;
    });

    // Add any remaining files to allFiles
    await Future.forEach(contentRef.allFiles.keys, (dynamic key) async {
      if (!allFiles.containsKey(key)) {
        allFiles[key] = await readByteContentFile(contentRef.allFiles[key]!);
      }
    });

    // Create an immutable EpubContent with all files included
    return EpubContent(
      html: html,
      css: css,
      images: images,
      fonts: fonts,
      allFiles: allFiles,
    );
  }

  static Future<Map<String, EpubTextContentFile>> readTextContentFiles(
      Map<String, EpubTextContentFileRef> textContentFileRefs) async {
    var result = <String, EpubTextContentFile>{};

    await Future.forEach(textContentFileRefs.keys, (dynamic key) async {
      EpubContentFileRef value = textContentFileRefs[key]!;
      var content = await value.readContentAsText();

      result[key] = EpubTextContentFile(
        fileName: value.fileName,
        contentType: value.contentType,
        contentMimeType: value.contentMimeType,
        content: content,
      );
    });
    return result;
  }

  static Future<Map<String, EpubByteContentFile>> readByteContentFiles(
      Map<String, EpubByteContentFileRef> byteContentFileRefs) async {
    var result = <String, EpubByteContentFile>{};
    await Future.forEach(byteContentFileRefs.keys, (dynamic key) async {
      result[key] = await readByteContentFile(byteContentFileRefs[key]!);
    });
    return result;
  }

  static Future<EpubByteContentFile> readByteContentFile(
      EpubContentFileRef contentFileRef) async {
    var content = await contentFileRef.readContentAsBytes();

    return EpubByteContentFile(
      fileName: contentFileRef.fileName,
      contentType: contentFileRef.contentType,
      contentMimeType: contentFileRef.contentMimeType,
      content: content,
    );
  }

  static Future<List<EpubChapter>> readChapters(
      List<EpubChapterRef> chapterRefs) async {
    var result = <EpubChapter>[];
    await Future.forEach(chapterRefs, (EpubChapterRef chapterRef) async {
      var htmlContent = await chapterRef.readHtmlContent();
      var subChapters = await readChapters(chapterRef.subChapters!);

      result.add(EpubChapter(
        title: chapterRef.title,
        contentFileName: chapterRef.contentFileName,
        anchor: chapterRef.anchor,
        htmlContent: htmlContent,
        subChapters: subChapters,
        otherContentFileNames: chapterRef.otherContentFileNames,
      ));
    });
    return result;
  }
}
