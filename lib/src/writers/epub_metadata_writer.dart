// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:epubx/src/schema/opf/epub_metadata.dart';
import 'package:epubx/src/schema/opf/epub_version.dart';
import 'package:xml/xml.dart';

class EpubMetadataWriter {
  static const _dc_namespace = 'http://purl.org/dc/elements/1.1/';
  static const _opf_namespace = 'http://www.idpf.org/2007/opf';

  static void writeMetadata(
      XmlBuilder builder, EpubMetadata? meta, EpubVersion? version) {
    builder.element(
      'metadata',
      namespaceUris: {'opf': _opf_namespace, 'dc': _dc_namespace},
      nest: () {
        meta!
          ..titles?.forEach((item) =>
              builder.element('title', nest: item, namespaceUri: _dc_namespace))
          ..creators?.forEach((item) =>
              builder.element('creator', namespaceUri: _dc_namespace, nest: () {
                if (item.role != null) {
                  builder.attribute('role', item.role!,
                      namespaceUri: _opf_namespace);
                }
                if (item.fileAs != null) {
                  builder.attribute('file-as', item.fileAs!,
                      namespaceUri: _opf_namespace);
                }
                builder.text(item.creator!);
              }))
          ..subjects?.forEach((item) => builder.element('subject',
              namespaceUri: _dc_namespace, nest: item))
          ..publishers?.forEach((item) => builder.element('publisher',
              namespaceUri: _dc_namespace, nest: item))
          ..contributors?.forEach((item) => builder.element('contributor',
                  namespaceUri: _dc_namespace, nest: () {
                if (item.role != null) {
                  builder.attribute('role', item.role!,
                      namespaceUri: _opf_namespace);
                }
                if (item.fileAs != null) {
                  builder.attribute('file-as', item.fileAs!,
                      namespaceUri: _opf_namespace);
                }
                builder.text(item.contributor!);
              }))
          ..dates?.forEach((date) =>
              builder.element('date', namespaceUri: _dc_namespace, nest: () {
                if (date.event != null) {
                  builder.attribute('event', date.event!,
                      namespaceUri: _opf_namespace);
                }
                builder.text(date.date!);
              }))
          ..types?.forEach((type) =>
              builder.element('type', namespaceUri: _dc_namespace, nest: type))
          ..formats?.forEach((format) => builder.element('format',
              namespaceUri: _dc_namespace, nest: format))
          ..identifiers?.forEach((id) => builder
                  .element('identifier', namespaceUri: _dc_namespace, nest: () {
                if (id.id != null) builder.attribute('id', id.id!);
                if (id.scheme != null) {
                  builder.attribute('scheme', id.scheme!,
                      namespaceUri: _opf_namespace);
                }
                builder.text(id.identifier!);
              }))
          ..sources?.forEach((item) => builder.element('source',
              namespaceUri: _dc_namespace, nest: item))
          ..languages?.forEach((item) => builder.element('language',
              namespaceUri: _dc_namespace, nest: item))
          ..relations?.forEach((item) => builder.element('relation',
              namespaceUri: _dc_namespace, nest: item))
          ..coverages?.forEach((item) => builder.element('coverage',
              namespaceUri: _dc_namespace, nest: item))
          ..rights?.forEach((item) => builder.element('rights',
              namespaceUri: _dc_namespace, nest: item))
          ..metaItems?.forEach((metaitem) => builder.element('meta', nest: () {
                if (version == EpubVersion.Epub2) {
                  if (metaitem.name != null) {
                    builder.attribute('name', metaitem.name!);
                  }
                  if (metaitem.content != null) {
                    builder.attribute('content', metaitem.content!);
                  }
                } else if (version == EpubVersion.Epub3) {
                  if (metaitem.id != null) {
                    builder.attribute('id', metaitem.id!);
                  }
                  if (metaitem.refines != null) {
                    builder.attribute('refines', metaitem.refines!);
                  }
                  if (metaitem.property != null) {
                    builder.attribute('property', metaitem.property!);
                  }
                  if (metaitem.scheme != null) {
                    builder.attribute('scheme', metaitem.scheme!);
                  }
                }
              }));

        if (meta.description != null) {
          builder.element('description',
              namespaceUri: _dc_namespace, nest: meta.description);
        }
      },
    );
  }
}
