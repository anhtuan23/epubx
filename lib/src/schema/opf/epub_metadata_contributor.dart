import 'package:equatable/equatable.dart';

class EpubMetadataContributor extends Equatable {
  final String? id;
  final String? role;
  final String? fileAs;
  final String? contributor;

  const EpubMetadataContributor({
    this.id,
    this.role,
    this.fileAs,
    this.contributor,
  });

  EpubMetadataContributor copyWith({
    String? id,
    String? role,
    String? fileAs,
    String? contributor,
  }) {
    return EpubMetadataContributor(
      id: id ?? this.id,
      role: role ?? this.role,
      fileAs: fileAs ?? this.fileAs,
      contributor: contributor ?? this.contributor,
    );
  }

  @override
  List<Object?> get props => [id, role, fileAs, contributor];
}
