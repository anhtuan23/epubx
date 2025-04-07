import 'package:equatable/equatable.dart';

class EpubNavigationDocTitle extends Equatable {
  final List<String>? titles;

  EpubNavigationDocTitle({List<String>? titles})
      : titles = titles ?? <String>[];

  EpubNavigationDocTitle copyWith({
    List<String>? titles,
  }) {
    return EpubNavigationDocTitle(
      titles: titles ?? this.titles,
    );
  }

  @override
  List<Object?> get props => [
        if (titles != null) ...titles!,
      ];
}
