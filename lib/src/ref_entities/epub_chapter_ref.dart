import 'dart:async';
import 'package:collection/collection.dart';

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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EpubChapterRef) return false;

    final listEquals = const DeepCollectionEquality().equals;

    return title == other.title &&
        contentFileName == other.contentFileName &&
        anchor == other.anchor &&
        epubTextContentFileRef == other.epubTextContentFileRef &&
        listEquals(otherTextContentFileRefs, other.otherTextContentFileRefs) &&
        listEquals(otherContentFileNames, other.otherContentFileNames) &&
        listEquals(subChapters, other.subChapters);
  }

  @override
  int get hashCode => Object.hash(
        title,
        contentFileName,
        anchor,
        epubTextContentFileRef,
        Object.hashAll(otherTextContentFileRefs),
        Object.hashAll(otherContentFileNames),
        Object.hashAll(subChapters ?? []),
      );

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
    return 'Title: $title, Subchapter count: ${subChapters?.length ?? 0}';
  }
}
