import 'package:equatable/equatable.dart';

class EpubMetadataIdentifier extends Equatable {
  final String? id;
  final String? scheme;
  final String? identifier;

  const EpubMetadataIdentifier({this.id, this.scheme, this.identifier});

  EpubMetadataIdentifier copyWith({
    String? id,
    String? scheme,
    String? identifier,
  }) {
    return EpubMetadataIdentifier(
      id: id ?? this.id,
      scheme: scheme ?? this.scheme,
      identifier: identifier ?? this.identifier,
    );
  }

  @override
  List<Object?> get props => [id, scheme, identifier];
}
