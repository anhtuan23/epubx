import 'package:equatable/equatable.dart';

class EpubSpineItemRef extends Equatable {
  final String? idRef;
  final bool? linear;

  const EpubSpineItemRef({
    this.idRef,
    this.linear,
  });

  @override
  List<Object?> get props => [idRef, linear];

  EpubSpineItemRef copyWith({
    String? idRef,
    bool? linear,
  }) {
    return EpubSpineItemRef(
      idRef: idRef ?? this.idRef,
      linear: linear ?? this.linear,
    );
  }
}
