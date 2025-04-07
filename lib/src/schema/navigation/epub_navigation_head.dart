import 'package:equatable/equatable.dart';
import 'epub_navigation_head_meta.dart';

class EpubNavigationHead extends Equatable {
  final List<EpubNavigationHeadMeta>? metadata;

  EpubNavigationHead({List<EpubNavigationHeadMeta>? metadata})
      : metadata = metadata ?? <EpubNavigationHeadMeta>[];

  EpubNavigationHead copyWith({
    List<EpubNavigationHeadMeta>? metadata,
  }) {
    return EpubNavigationHead(
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        if (metadata != null) ...metadata!,
      ];
}
