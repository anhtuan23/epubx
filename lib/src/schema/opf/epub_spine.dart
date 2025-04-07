import 'package:equatable/equatable.dart';

import 'epub_spine_item_ref.dart';

class EpubSpine extends Equatable {
  final String? tableOfContents;
  final List<EpubSpineItemRef>? items;
  final bool? ltr;

  const EpubSpine({
    this.tableOfContents,
    this.items,
    this.ltr,
  });

  @override
  List<Object?> get props => [tableOfContents, items, ltr];

  EpubSpine copyWith({
    String? tableOfContents,
    List<EpubSpineItemRef>? items,
    bool? ltr,
  }) {
    return EpubSpine(
      tableOfContents: tableOfContents ?? this.tableOfContents,
      items: items ?? this.items,
      ltr: ltr ?? this.ltr,
    );
  }

  EpubSpine addItem(EpubSpineItemRef item) {
    return EpubSpine(
      tableOfContents: tableOfContents,
      items: [...?items, item],
      ltr: ltr,
    );
  }
}
