import 'dart:async';

import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_text_content_file_ref.dart';

class EpubChapterRef {
  // Reference to Text content reader.
  EpubTextContentFileRef? epubTextContentFileRef;
  // If the chapter is split into multiple files, this list contains the references to content readers of the other files.
  List<EpubTextContentFileRef> otherTextContentFileRefs = [];

  String? title;
  String? contentFileName;
  String? anchor;
  List<EpubChapterRef>? subChapters;
  // If the chapter is split into multiple files, this list contains the names of the other files.
  List<String> otherContentFileNames = [];

  EpubChapterRef(this.epubTextContentFileRef);

  @override
  int get hashCode {
    var objects = [
      title.hashCode,
      contentFileName.hashCode,
      hashObjects(otherTextContentFileRefs),
      hashObjects(otherContentFileNames),
      anchor.hashCode,
      epubTextContentFileRef.hashCode,
      ...subChapters?.map((subChapter) => subChapter.hashCode) ?? [0],
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    if (other is! EpubChapterRef) {
      return false;
    }
    return title == other.title &&
        epubTextContentFileRef == other.epubTextContentFileRef &&
        contentFileName == other.contentFileName &&
        anchor == other.anchor &&
        collections.listsEqual(
            otherTextContentFileRefs, other.otherTextContentFileRefs) &&
        collections.listsEqual(
            otherContentFileNames, other.otherContentFileNames) &&
        collections.listsEqual(subChapters, other.subChapters);
  }

  Future<String> readHtmlContent() async {
    var contentFuture = epubTextContentFileRef!.readContentAsText();
    if (otherContentFileNames.isNotEmpty) {
      var allContentFutures = <Future<String>>[contentFuture];
      for (var otherContentFileRef in otherTextContentFileRefs) {
        allContentFutures.add(otherContentFileRef.readContentAsText());
      }
      return Future.wait(allContentFutures).then((List<String> contents) {
        return contents.join('');
      });
    } else {
      return contentFuture;
    }
  }

  @override
  String toString() {
    return 'Title: $title, Subchapter count: ${subChapters!.length}';
  }
}
