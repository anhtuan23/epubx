import 'package:equatable/equatable.dart';

import 'epub_navigation_label.dart';
import 'epub_navigation_target.dart';

class EpubNavigationList extends Equatable {
  final String? id;
  final String? className;
  final List<EpubNavigationLabel>? navigationLabels;
  final List<EpubNavigationTarget>? navigationTargets;

  EpubNavigationList({
    this.id,
    this.className,
    List<EpubNavigationLabel>? navigationLabels,
    List<EpubNavigationTarget>? navigationTargets,
  })  : navigationLabels = navigationLabels ?? <EpubNavigationLabel>[],
        navigationTargets = navigationTargets ?? <EpubNavigationTarget>[];

  EpubNavigationList copyWith({
    String? id,
    String? className,
    List<EpubNavigationLabel>? navigationLabels,
    List<EpubNavigationTarget>? navigationTargets,
  }) {
    return EpubNavigationList(
      id: id ?? this.id,
      className: className ?? this.className,
      navigationLabels: navigationLabels ?? this.navigationLabels,
      navigationTargets: navigationTargets ?? this.navigationTargets,
    );
  }

  @override
  List<Object?> get props => [
        id,
        className,
        if (navigationLabels != null) ...navigationLabels!,
        if (navigationTargets != null) ...navigationTargets!,
      ];
}
