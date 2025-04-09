import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_chapter_ref.dart';
import '../ref_entities/epub_text_content_file_ref.dart';
import '../schema/navigation/epub_navigation_point.dart';

class ChapterReader {
  static List<EpubChapterRef> getChapters(EpubBookRef bookRef) {
    // First try to get chapters from navigation
    var chaptersFromNavigation = <EpubChapterRef>[];
    if (bookRef.schema?.navigation != null &&
        bookRef.schema!.navigation!.navMap != null &&
        bookRef.schema!.navigation!.navMap!.points != null &&
        bookRef.schema!.navigation!.navMap!.points!.isNotEmpty) {
      chaptersFromNavigation =
          getChaptersImpl(bookRef, bookRef.schema!.navigation!.navMap!.points!);
    }

    // If we got chapters from navigation, return them
    if (chaptersFromNavigation.isNotEmpty) {
      return chaptersFromNavigation;
    }

    // Otherwise, generate chapters from content files
    print(
        'Warning: No chapters found in navigation structure. Creating chapters from content files.');
    return generateChaptersFromContent(bookRef);
  }

  // Generate chapters from HTML content files
  static List<EpubChapterRef> generateChaptersFromContent(EpubBookRef bookRef) {
    var result = <EpubChapterRef>[];

    // Skip these common non-chapter files
    var filesToSkip = [
      'cover',
      'title',
      'copyright',
      'about',
      'acknowledgements',
      'dedication',
      'epigraph',
      'halftitle',
      'titlepage',
      'seal'
    ];

    // Process HTML files in order
    var orderedHtmlFiles = bookRef.content!.html.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    for (var htmlFilePath in orderedHtmlFiles) {
      var fileName = htmlFilePath.split('/').last.toLowerCase();

      // Skip common non-chapter files
      if (filesToSkip.any((skip) => fileName.contains(skip.toLowerCase()))) {
        continue;
      }

      var htmlContentFileRef = bookRef.content!.html[htmlFilePath];
      var chapterRef = EpubChapterRef(htmlContentFileRef);

      // Extract title from the file name for better display
      var title = fileName.split('.').first;
      // Remove common prefixes like "Section" or "Chapter"
      title = title.replaceAll(
          RegExp(r'^(section|chapter|part)', caseSensitive: false), '');
      // Clean up the title
      title = title.trim();
      if (title.isEmpty) {
        title = "Chapter $htmlFilePath";
      } else if (RegExp(r'^\d+$').hasMatch(title)) {
        title = "Chapter $title";
      }

      chapterRef.title = title;
      chapterRef.contentFileName = htmlFilePath;
      // Initialize subChapters to an empty list to prevent null reference errors
      chapterRef.subChapters = [];
      result.add(chapterRef);
    }

    print('Number of chapters found: ${result.length}');
    return result;
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
