import 'package:equatable/equatable.dart';

class EpubNavigationDocAuthor extends Equatable {
  final List<String>? authors;

  EpubNavigationDocAuthor({List<String>? authors})
      : authors = authors ?? <String>[];

  EpubNavigationDocAuthor copyWith({
    List<String>? authors,
  }) {
    return EpubNavigationDocAuthor(
      authors: authors ?? this.authors,
    );
  }

  @override
  List<Object?> get props => [
        if (authors != null) ...authors!,
      ];
}
