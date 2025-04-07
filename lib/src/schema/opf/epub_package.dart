import 'package:equatable/equatable.dart';

import 'epub_guide.dart';
import 'epub_manifest.dart';
import 'epub_metadata.dart';
import 'epub_spine.dart';
import 'epub_version.dart';

class EpubPackage extends Equatable {
  final EpubVersion? version;
  final EpubMetadata? metadata;
  final EpubManifest? manifest;
  final EpubSpine? spine;
  final EpubGuide? guide;
  final String? uniqueIdentifier;

  EpubPackage({
    this.version,
    this.metadata,
    this.manifest,
    this.spine,
    this.guide,
    this.uniqueIdentifier,
  });

  EpubPackage copyWith({
    EpubVersion? version,
    EpubMetadata? metadata,
    EpubManifest? manifest,
    EpubSpine? spine,
    EpubGuide? guide,
    String? uniqueIdentifier,
  }) {
    return EpubPackage(
      version: version ?? this.version,
      metadata: metadata ?? this.metadata,
      manifest: manifest ?? this.manifest,
      spine: spine ?? this.spine,
      guide: guide ?? this.guide,
      uniqueIdentifier: uniqueIdentifier ?? this.uniqueIdentifier,
    );
  }

  @override
  List<Object?> get props => [
        version,
        metadata,
        manifest,
        spine,
        guide,
        uniqueIdentifier,
      ];
}
