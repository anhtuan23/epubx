import 'package:equatable/equatable.dart';

import 'epub_navigation_point.dart';

class EpubNavigationMap extends Equatable {
  final List<EpubNavigationPoint>? points;

  EpubNavigationMap({List<EpubNavigationPoint>? points})
      : points = points ?? <EpubNavigationPoint>[];

  EpubNavigationMap copyWith({
    List<EpubNavigationPoint>? points,
  }) {
    return EpubNavigationMap(
      points: points ?? this.points,
    );
  }

  @override
  List<Object?> get props => [
        if (points != null) ...points!,
      ];
}
