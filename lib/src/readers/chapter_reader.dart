import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_chapter_ref.dart';
import '../ref_entities/epub_text_content_file_ref.dart';
import '../schema/navigation/epub_navigation_point.dart';

class ChapterReader {
  static List<EpubChapterRef> getChapters(EpubBookRef bookRef) {
    if (bookRef.schema!.navigation == null) {
      return <EpubChapterRef>[];
    }
    return getChaptersImpl(
        bookRef, bookRef.schema!.navigation!.navMap!.points!);
  }

  static List<EpubChapterRef> getChaptersImpl(
      EpubBookRef bookRef, List<EpubNavigationPoint> navigationPoints) {
    var result = <EpubChapterRef>[];
    for (var navigationPoint in navigationPoints) {
      // Skip navigation points with null or empty content sources
      if (navigationPoint.content?.source == null ||
          navigationPoint.content!.source!.isEmpty ||
          navigationPoint.content!.source == '#') {
        print(
            'Warning: Skipping navigation point with empty content source: ${navigationPoint.navigationLabels?.first.text ?? "Untitled"}');
        continue;
      }

      String? contentFileName;
      String? anchor;
      var contentSourceAnchorCharIndex =
          navigationPoint.content!.source!.indexOf('#');
      if (contentSourceAnchorCharIndex == -1) {
        contentFileName = navigationPoint.content!.source;
        anchor = null;
      } else {
        contentFileName = navigationPoint.content!.source!
            .substring(0, contentSourceAnchorCharIndex);
        anchor = navigationPoint.content!.source!
            .substring(contentSourceAnchorCharIndex + 1);
      }

      // Handle empty content file names
      if (contentFileName == null || contentFileName.isEmpty) {
        print(
            'Warning: Empty content file name in navigation point: ${navigationPoint.navigationLabels?.first.text ?? "Untitled"}');
        continue;
      }

      contentFileName = Uri.decodeFull(contentFileName);
      EpubTextContentFileRef? htmlContentFileRef;
      if (!bookRef.content!.html.containsKey(contentFileName)) {
        // Instead of throwing an exception, log a warning and skip this navigation point
        print(
            'Warning: Item with href = "$contentFileName" is missing in EPUB manifest. Skipping navigation point: ${navigationPoint.navigationLabels?.first.text ?? "Untitled"}');
        continue;
      }

      htmlContentFileRef = bookRef.content!.html[contentFileName];
      var chapterRef = EpubChapterRef(htmlContentFileRef);
      chapterRef.contentFileName = contentFileName;
      chapterRef.anchor = anchor;
      chapterRef.title = navigationPoint.navigationLabels!.first.text;
      chapterRef.subChapters =
          getChaptersImpl(bookRef, navigationPoint.childNavigationPoints!);

      if (chapterRef.contentFileName!.contains('_split_')) {
        var fileNamePart = chapterRef.contentFileName!.split('_split_')[0];
        for (var fileName in bookRef.content!.html.keys) {
          if (fileName.contains(fileNamePart)) {
            if (fileName == contentFileName) {
              continue;
            }
            chapterRef.otherTextContentFileRefs
                .add(bookRef.content!.html[fileName]!);
            chapterRef.otherContentFileNames.add(fileName);
          }
        }
      }

      result.add(chapterRef);
    }
    return result;
  }
}
