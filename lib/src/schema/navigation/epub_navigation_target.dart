import 'package:epubx/src/schema/navigation/epub_metadata.dart';
import 'package:equatable/equatable.dart';

import 'epub_navigation_label.dart';

class EpubNavigationTarget extends Equatable {
  final String? id;
  final String? className;
  final String? value;
  final String? playOrder;
  final List<EpubNavigationLabel>? navigationLabels;
  final EpubNavigationContent? content;

  EpubNavigationTarget({
    this.id,
    this.className,
    this.value,
    this.playOrder,
    List<EpubNavigationLabel>? navigationLabels,
    this.content,
  }) : navigationLabels = navigationLabels ?? <EpubNavigationLabel>[];

  EpubNavigationTarget copyWith({
    String? id,
    String? className,
    String? value,
    String? playOrder,
    List<EpubNavigationLabel>? navigationLabels,
    EpubNavigationContent? content,
  }) {
    return EpubNavigationTarget(
      id: id ?? this.id,
      className: className ?? this.className,
      value: value ?? this.value,
      playOrder: playOrder ?? this.playOrder,
      navigationLabels: navigationLabels ?? this.navigationLabels,
      content: content ?? this.content,
    );
  }

  @override
  List<Object?> get props => [
        id,
        className,
        value,
        playOrder,
        content,
        if (navigationLabels != null) ...navigationLabels!,
      ];
}
