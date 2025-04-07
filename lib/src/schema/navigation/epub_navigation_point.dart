import 'package:epubx/src/schema/navigation/epub_metadata.dart';
import 'package:equatable/equatable.dart';

import 'epub_navigation_label.dart';

class EpubNavigationPoint extends Equatable {
  final String? id;
  final String? className;
  final String? playOrder;
  final List<EpubNavigationLabel>? navigationLabels;
  final EpubNavigationContent? content;
  final List<EpubNavigationPoint>? childNavigationPoints;

  EpubNavigationPoint({
    this.id,
    this.className,
    this.playOrder,
    List<EpubNavigationLabel>? navigationLabels,
    this.content,
    List<EpubNavigationPoint>? childNavigationPoints,
  })  : navigationLabels = navigationLabels ?? <EpubNavigationLabel>[],
        childNavigationPoints =
            childNavigationPoints ?? <EpubNavigationPoint>[];

  EpubNavigationPoint copyWith({
    String? id,
    String? className,
    String? playOrder,
    List<EpubNavigationLabel>? navigationLabels,
    EpubNavigationContent? content,
    List<EpubNavigationPoint>? childNavigationPoints,
  }) {
    return EpubNavigationPoint(
      id: id ?? this.id,
      className: className ?? this.className,
      playOrder: playOrder ?? this.playOrder,
      navigationLabels: navigationLabels ?? this.navigationLabels,
      content: content ?? this.content,
      childNavigationPoints:
          childNavigationPoints ?? this.childNavigationPoints,
    );
  }

  @override
  List<Object?> get props => [
        id,
        className,
        playOrder,
        content,
        if (navigationLabels != null) ...navigationLabels!,
        if (childNavigationPoints != null) ...childNavigationPoints!,
      ];
}
