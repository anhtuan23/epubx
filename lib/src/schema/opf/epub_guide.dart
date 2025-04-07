import 'package:equatable/equatable.dart';

import 'epub_guide_reference.dart';

class EpubGuide extends Equatable {
  final List<EpubGuideReference>? items;

  EpubGuide({List<EpubGuideReference>? items})
      : items = items ?? <EpubGuideReference>[];

  @override
  List<Object?> get props => [
        if (items != null) ...items!,
      ];
}
