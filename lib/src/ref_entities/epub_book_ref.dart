import 'dart:async';

import 'package:archive/archive.dart';
import 'package:image/image.dart';
import 'package:collection/collection.dart';

import '../entities/epub_schema.dart';
import '../readers/book_cover_reader.dart';
import '../readers/chapter_reader.dart';
import 'epub_chapter_ref.dart';
import 'epub_content_ref.dart';

class EpubBookRef {
  final Archive? _epubArchive;

  String? title;
  String? author;
  List<String?>? authorList;
  EpubSchema? schema;
  EpubContentRef? content;

  EpubBookRef(Archive epubArchive) : _epubArchive = epubArchive;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EpubBookRef) return false;

    final listEquals = const DeepCollectionEquality().equals;

    return title == other.title &&
        author == other.author &&
        schema == other.schema &&
        content == other.content &&
        listEquals(authorList, other.authorList);
  }

  @override
  int get hashCode => Object.hash(
        title,
        author,
        schema,
        content,
        Object.hashAll(authorList ?? []),
      );

  Archive? epubArchive() {
    return _epubArchive;
  }

  Future<List<EpubChapterRef>> getChapters() async {
    return ChapterReader.getChapters(this);
  }

  Future<Image?> readCover() async {
    return await BookCoverReader.readBookCover(this);
  }
}
