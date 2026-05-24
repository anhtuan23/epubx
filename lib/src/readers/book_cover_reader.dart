import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:image/image.dart' as images;

import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_byte_content_file_ref.dart';
import '../schema/opf/epub_manifest_item.dart';
import '../schema/opf/epub_metadata_meta.dart';

class BookCoverReader {
  static Future<images.Image?> readBookCover(EpubBookRef bookRef) async {
    try {
      var metaItems = bookRef.schema!.package!.metadata!.metaItems;
      if (metaItems == null || metaItems.isEmpty) return null;

      var coverMetaItem = metaItems.firstWhereOrNull(
          (EpubMetadataMeta metaItem) =>
              metaItem.name != null && metaItem.name!.toLowerCase() == 'cover');
      if (coverMetaItem == null) return null;
      if (coverMetaItem.content == null || coverMetaItem.content!.isEmpty) {
        print(
            'Warning: Incorrect EPUB metadata: cover item content is missing.');
        return null;
      }

      var coverManifestItem = bookRef.schema!.package!.manifest!.items!
          .firstWhereOrNull((EpubManifestItem manifestItem) =>
              manifestItem.id!.toLowerCase() ==
              coverMetaItem.content!.toLowerCase());
      if (coverManifestItem == null) {
        print(
            'Warning: Incorrect EPUB manifest: item with ID = "${coverMetaItem.content}" is missing.');
        return null;
      }

      EpubByteContentFileRef? coverImageContentFileRef;
      if (!bookRef.content!.images.containsKey(coverManifestItem.href)) {
        print(
            'Warning: Incorrect EPUB manifest: item with href = "${coverManifestItem.href}" is missing.');
        return null;
      }

      coverImageContentFileRef =
          bookRef.content!.images[coverManifestItem.href];
      var coverImageContent =
          await coverImageContentFileRef!.readContentAsBytes();
      var retval = images.decodeImage(Uint8List.fromList(coverImageContent));
      return retval;
    } on Exception catch (e) {
      print('Error reading book cover: $e');
      return null;
    }
  }
}
