import 'package:equatable/equatable.dart';

class EpubGuideReference extends Equatable {
  final String? type;
  final String? title;
  final String? href;

  EpubGuideReference({
    this.type,
    this.title,
    this.href,
  });

  EpubGuideReference copyWith({
    String? type,
    String? title,
    String? href,
  }) {
    return EpubGuideReference(
      type: type ?? this.type,
      title: title ?? this.title,
      href: href ?? this.href,
    );
  }

  @override
  List<Object?> get props => [type, title, href];
}
