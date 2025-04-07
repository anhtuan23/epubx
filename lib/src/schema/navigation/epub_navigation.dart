import 'package:equatable/equatable.dart';

import 'epub_navigation_doc_author.dart';
import 'epub_navigation_doc_title.dart';
import 'epub_navigation_head.dart';
import 'epub_navigation_list.dart';
import 'epub_navigation_map.dart';
import 'epub_navigation_page_list.dart';

class EpubNavigation extends Equatable {
  final EpubNavigationHead? head;
  final EpubNavigationDocTitle? docTitle;
  final List<EpubNavigationDocAuthor>? docAuthors;
  final EpubNavigationMap? navMap;
  final EpubNavigationPageList? pageList;
  final List<EpubNavigationList>? navLists;
  final String? fileName;

  EpubNavigation({
    this.head,
    this.docTitle,
    this.docAuthors,
    this.navMap,
    this.pageList,
    this.navLists,
    this.fileName,
  });

  EpubNavigation copyWith({
    EpubNavigationHead? head,
    EpubNavigationDocTitle? docTitle,
    List<EpubNavigationDocAuthor>? docAuthors,
    EpubNavigationMap? navMap,
    EpubNavigationPageList? pageList,
    List<EpubNavigationList>? navLists,
    String? fileName,
  }) {
    return EpubNavigation(
      head: head ?? this.head,
      docTitle: docTitle ?? this.docTitle,
      docAuthors: docAuthors ?? this.docAuthors,
      navMap: navMap ?? this.navMap,
      pageList: pageList ?? this.pageList,
      navLists: navLists ?? this.navLists,
      fileName: fileName ?? this.fileName,
    );
  }

  @override
  List<Object?> get props => [
        head,
        docTitle,
        navMap,
        pageList,
        fileName,
        // Include each item in the lists to ensure proper equality
        if (docAuthors != null) ...docAuthors!,
        if (navLists != null) ...navLists!,
      ];
}
