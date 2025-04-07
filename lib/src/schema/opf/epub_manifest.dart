import 'package:equatable/equatable.dart';

import 'epub_manifest_item.dart';

class EpubManifest extends Equatable {
  final List<EpubManifestItem>? items;

  EpubManifest({List<EpubManifestItem>? items})
      : items = items ?? <EpubManifestItem>[];

  @override
  List<Object?> get props => [
        if (items != null) ...items!,
      ];
}
