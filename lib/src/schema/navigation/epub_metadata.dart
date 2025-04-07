import 'package:equatable/equatable.dart';

class EpubNavigationContent extends Equatable {
  final String? id;
  final String? source;

  EpubNavigationContent({
    this.id,
    this.source,
  });

  EpubNavigationContent copyWith({
    String? id,
    String? source,
  }) {
    return EpubNavigationContent(
      id: id ?? this.id,
      source: source ?? this.source,
    );
  }

  @override
  List<Object?> get props => [id, source];

  @override
  String toString() {
    return 'Source: $source';
  }
}
