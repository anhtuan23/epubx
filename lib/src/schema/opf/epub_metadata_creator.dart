import 'package:equatable/equatable.dart';

class EpubMetadataCreator extends Equatable {
  final String? id;
  final String? role;
  final String? fileAs;
  final String? creator;

  const EpubMetadataCreator({
    this.id,
    this.role,
    this.fileAs,
    this.creator,
  });

  EpubMetadataCreator copyWith({
    String? id,
    String? role,
    String? fileAs,
    String? creator,
  }) {
    return EpubMetadataCreator(
      id: id ?? this.id,
      role: role ?? this.role,
      fileAs: fileAs ?? this.fileAs,
      creator: creator ?? this.creator,
    );
  }

  @override
  List<Object?> get props => [id, role, fileAs, creator];
}
