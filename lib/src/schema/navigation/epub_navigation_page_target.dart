import 'package:epubx/src/schema/navigation/epub_metadata.dart';
import 'package:epubx/src/schema/navigation/epub_navigation_page_target_type.dart';
import 'package:equatable/equatable.dart';

import 'epub_navigation_label.dart';

class EpubNavigationPageTarget extends Equatable {
  final String? id;
  final String? value;
  final EpubNavigationPageTargetType? type;
  final String? className;
  final String? playOrder;
  final List<EpubNavigationLabel>? navigationLabels;
  final EpubNavigationContent? content;

  EpubNavigationPageTarget({
    this.id,
    this.value,
    this.type,
    this.className,
    this.playOrder,
    List<EpubNavigationLabel>? navigationLabels,
    this.content,
  }) : navigationLabels = navigationLabels ?? <EpubNavigationLabel>[];

  EpubNavigationPageTarget copyWith({
    String? id,
    String? value,
    EpubNavigationPageTargetType? type,
    String? className,
    String? playOrder,
    List<EpubNavigationLabel>? navigationLabels,
    EpubNavigationContent? content,
  }) {
    return EpubNavigationPageTarget(
      id: id ?? this.id,
      value: value ?? this.value,
      type: type ?? this.type,
      className: className ?? this.className,
      playOrder: playOrder ?? this.playOrder,
      navigationLabels: navigationLabels ?? this.navigationLabels,
      content: content ?? this.content,
    );
  }

  @override
  List<Object?> get props => [
        id,
        value,
        type,
        className,
        playOrder,
        content,
        if (navigationLabels != null) ...navigationLabels!,
      ];
}
