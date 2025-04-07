import 'package:equatable/equatable.dart';

class EpubNavigationHeadMeta extends Equatable {
  final String? name;
  final String? content;
  final String? scheme;

  EpubNavigationHeadMeta({this.name, this.content, this.scheme});

  EpubNavigationHeadMeta copyWith({
    String? name,
    String? content,
    String? scheme,
  }) {
    return EpubNavigationHeadMeta(
      name: name ?? this.name,
      content: content ?? this.content,
      scheme: scheme ?? this.scheme,
    );
  }

  @override
  List<Object?> get props => [name, content, scheme];
}
