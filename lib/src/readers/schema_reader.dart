import 'dart:async';

import 'package:archive/archive.dart';

import '../entities/epub_schema.dart';
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
}
