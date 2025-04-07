import 'package:equatable/equatable.dart';

class EpubNavigationLabel extends Equatable {
  final String? text;

  EpubNavigationLabel({this.text});

  EpubNavigationLabel copyWith({
    String? text,
  }) {
    return EpubNavigationLabel(
      text: text ?? this.text,
    );
  }

  @override
  List<Object?> get props => [text];
}
