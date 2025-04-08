import 'dart:async';

import 'package:archive/archive.dart';

import '../entities/epub_schema.dart';
import '../schema/opf/epub_manifest.dart';
import '../schema/opf/epub_manifest_item.dart';
import '../schema/opf/epub_metadata.dart';
import '../schema/opf/epub_metadata_contributor.dart';
import '../schema/opf/epub_metadata_creator.dart';
import '../schema/opf/epub_metadata_date.dart';
import '../schema/opf/epub_metadata_identifier.dart';
import '../schema/opf/epub_metadata_meta.dart';
import '../schema/opf/epub_package.dart';
import '../schema/opf/epub_spine.dart';
import '../schema/opf/epub_spine_item_ref.dart';
import '../schema/opf/epub_version.dart';
import '../utils/zip_path_utils.dart';
import 'navigation_reader.dart';
import 'package_reader.dart';
import 'root_file_path_reader.dart';

class SchemaReader {
  static Future<EpubSchema> readSchema(Archive epubArchive) async {
    var rootFilePath = (await RootFilePathReader.getRootFilePath(epubArchive))!;
    var contentDirectoryPath = ZipPathUtils.getDirectoryPath(rootFilePath);
    var package = await PackageReader.readPackage(epubArchive, rootFilePath);
    var navigation = await NavigationReader.readNavigation(
        epubArchive, contentDirectoryPath, package);

    return EpubSchema(
      contentDirectoryPath: contentDirectoryPath,
      package: package,
      navigation: navigation,
    );
  }

  /// Creates a minimal valid schema structure for fallback when parsing fails
  static EpubSchema createMinimalSchema() {
    return EpubSchema(
      package: EpubPackage(
          metadata: EpubMetadata(
            titles: <String>[''],
            creators: <EpubMetadataCreator>[],
            subjects: <String>[],
            publishers: <String>[],
            contributors: <EpubMetadataContributor>[],
            dates: <EpubMetadataDate>[],
            types: <String>[],
            formats: <String>[],
            identifiers: <EpubMetadataIdentifier>[],
            sources: <String>[],
            languages: <String>[],
            relations: <String>[],
            coverages: <String>[],
            rights: <String>[],
            metaItems: <EpubMetadataMeta>[],
          ),
          manifest: EpubManifest(items: <EpubManifestItem>[]),
          spine: EpubSpine(items: <EpubSpineItemRef>[]),
          version: EpubVersion.Epub3),
      navigation: null,
    );
  }
}
