import 'package:equatable/equatable.dart';

import 'epub_navigation_page_target.dart';

class EpubNavigationPageList extends Equatable {
  final List<EpubNavigationPageTarget>? pageTargets;

  EpubNavigationPageList({List<EpubNavigationPageTarget>? pageTargets})
      : pageTargets = pageTargets ?? <EpubNavigationPageTarget>[];


  EpubNavigationPageList addPageTarget(EpubNavigationPageTarget pageTarget) {
    final newTargets = List<EpubNavigationPageTarget>.from(pageTargets ?? [])..add(pageTarget);
    return copyWith(pageTargets: newTargets);
  }

  EpubNavigationPageList copyWith({
    List<EpubNavigationPageTarget>? pageTargets,
  }) {
    return EpubNavigationPageList(
      pageTargets: pageTargets ?? this.pageTargets,
    );
  }

  @override
  List<Object?> get props => [
        if (pageTargets != null) ...pageTargets!,
      ];
}
