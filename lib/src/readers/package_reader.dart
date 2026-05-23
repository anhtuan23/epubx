import 'dart:async';

import 'package:archive/archive.dart';
import 'dart:convert' as convert;
import 'package:collection/collection.dart' show IterableExtension;
import 'package:xml/xml.dart';

import '../schema/opf/epub_guide.dart';
import '../schema/opf/epub_guide_reference.dart';
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

class PackageReader {
  static EpubGuide readGuide(XmlElement guideNode) {
    var result = EpubGuide(items: <EpubGuideReference>[]);
    guideNode.children
        .whereType<XmlElement>()
        .forEach((XmlElement guideReferenceNode) {
      if (guideReferenceNode.name.local.toLowerCase() == 'reference') {
        var guideReference = EpubGuideReference();
        for (var guideReferenceNodeAttribute in guideReferenceNode.attributes) {
          var attributeValue = guideReferenceNodeAttribute.value;
          switch (guideReferenceNodeAttribute.name.local.toLowerCase()) {
            case 'type':
              guideReference = guideReference.copyWith(
                type: attributeValue,
              );
              break;
            case 'title':
              guideReference = guideReference.copyWith(title: attributeValue);
              break;
            case 'href':
              guideReference = guideReference.copyWith(href: attributeValue);
              break;
          }
        }
        if (guideReference.type == null || guideReference.type!.isEmpty) {
          throw Exception('Incorrect EPUB guide: item type is missing');
        }
        if (guideReference.href == null || guideReference.href!.isEmpty) {
          throw Exception('Incorrect EPUB guide: item href is missing');
        }
        result.items!.add(guideReference);
      }
    });
    return result;
  }

  static EpubManifestItem readManifestItem(XmlElement manifestItemNode) {
    var result = EpubManifestItem();

    if (manifestItemNode.attributes.isEmpty) {
      throw Exception('Incorrect EPUB manifest: item attributes are missing.');
    }

    for (var manifestItemNodeAttribute in manifestItemNode.attributes) {
      var attributeValue = manifestItemNodeAttribute.value;
      switch (manifestItemNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          result = result.copyWith(id: attributeValue);
          break;
        case 'href':
          // Sanitize the href - replace empty hrefs with a placeholder
          if (attributeValue.isEmpty) {
            print(
                'Warning: Empty href found in manifest item, using placeholder.');
            result = result.copyWith(href: 'empty-href-placeholder');
          } else {
            result = result.copyWith(href: attributeValue);
          }
          break;
        case 'media-type':
          result = result.copyWith(mediaType: attributeValue);
          break;
        case 'required-namespace':
          result = result.copyWith(requiredNamespace: attributeValue);
          break;
        case 'required-modules':
          result = result.copyWith(requiredModules: attributeValue);
          break;
        case 'fallback':
          result = result.copyWith(fallback: attributeValue);
          break;
        case 'fallback-style':
          result = result.copyWith(fallbackStyle: attributeValue);
          break;
        case 'properties':
          result = result.copyWith(properties: attributeValue);
          break;
      }
    }

    if (result.id == null || result.id!.isEmpty) {
      throw Exception('Incorrect EPUB manifest: item ID is missing.');
    }

    // Don't throw an error for empty href, just warn
    if (result.href == null) {
      print(
          'Warning: null href in manifest item ${result.id}, using placeholder.');
      result = result.copyWith(href: 'empty-href-placeholder');
    }

    if (result.mediaType == null || result.mediaType!.isEmpty) {
      throw Exception('Incorrect EPUB manifest: item media type is missing.');
    }

    return result;
  }

  static EpubManifest readManifest(XmlElement manifestNode) {
    var result = EpubManifest(items: <EpubManifestItem>[]);
    manifestNode.children
        .whereType<XmlElement>()
        .forEach((XmlElement manifestItemNode) {
      if (manifestItemNode.name.local.toLowerCase() == 'item') {
        var manifestItem = readManifestItem(manifestItemNode);
        result.items!.add(manifestItem);
      }
    });
    return result;
  }

  static EpubMetadata readMetadata(
      XmlElement metadataNode, EpubVersion? epubVersion) {
    var result = EpubMetadata(
      titles: <String>[],
      creators: <EpubMetadataCreator>[],
      subjects: <String>[],
      description: '',
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
    );
    metadataNode.children
        .whereType<XmlElement>()
        .forEach((XmlElement metadataItemNode) {
      var innerText = metadataItemNode.innerText;
      switch (metadataItemNode.name.local.toLowerCase()) {
        case 'title':
          result = result.addItem(title: innerText);
          break;
        case 'creator':
          var creator = readMetadataCreator(metadataItemNode);
          result = result.addItem(creator: creator);
          break;
        case 'subject':
          result = result.addItem(subject: innerText);
          break;
        case 'description':
          result = result.copyWith(description: innerText);
          break;
        case 'publisher':
          result = result.addItem(publisher: innerText);
          break;
        case 'contributor':
          var contributor = readMetadataContributor(metadataItemNode);
          result = result.addItem(contributor: contributor);
          break;
        case 'date':
          var date = readMetadataDate(metadataItemNode);
          result = result.addItem(date: date);
          break;
        case 'type':
          result = result.addItem(type: innerText);
          break;
        case 'format':
          result = result.addItem(format: innerText);
          break;
        case 'identifier':
          var identifier = readMetadataIdentifier(metadataItemNode);
          result = result.addItem(identifier: identifier);
          break;
        case 'source':
          result = result.addItem(source: innerText);
          break;
        case 'language':
          result = result.addItem(language: innerText);
          break;
        case 'relation':
          result = result.addItem(relation: innerText);
          break;
        case 'coverage':
          result = result.addItem(coverage: innerText);
          break;
        case 'rights':
          result = result.addItem(right: innerText);
          break;
        case 'meta':
          if (epubVersion == EpubVersion.Epub2) {
            var meta = readMetadataMetaVersion2(metadataItemNode);
            result = result.addItem(metaItem: meta);
          } else if (epubVersion == EpubVersion.Epub3) {
            var meta = readMetadataMetaVersion3(metadataItemNode);
            result = result.addItem(metaItem: meta);
          }
          break;
      }
    });
    return result;
  }

  static EpubMetadataContributor readMetadataContributor(
      XmlElement metadataContributorNode) {
    var result = EpubMetadataContributor();
    for (var metadataContributorNodeAttribute
        in metadataContributorNode.attributes) {
      var attributeValue = metadataContributorNodeAttribute.value;
      switch (metadataContributorNodeAttribute.name.local.toLowerCase()) {
        case 'role':
          result = result.copyWith(role: attributeValue);
          break;
        case 'file-as':
          result = result.copyWith(fileAs: attributeValue);
          break;
      }
    }
    result = result.copyWith(contributor: metadataContributorNode.innerText);
    return result;
  }

  static EpubMetadataCreator readMetadataCreator(
      XmlElement metadataCreatorNode) {
    var result = EpubMetadataCreator();
    for (var metadataCreatorNodeAttribute in metadataCreatorNode.attributes) {
      var attributeValue = metadataCreatorNodeAttribute.value;
      switch (metadataCreatorNodeAttribute.name.local.toLowerCase()) {
        case 'role':
          result = result.copyWith(role: attributeValue);
          break;
        case 'file-as':
          result = result.copyWith(fileAs: attributeValue);
          break;
      }
    }
    result = result.copyWith(creator: metadataCreatorNode.innerText);
    return result;
  }

  static EpubMetadataDate readMetadataDate(XmlElement metadataDateNode) {
    var result = EpubMetadataDate();
    var eventAttribute = metadataDateNode.getAttribute('event',
        namespaceUri: metadataDateNode.name.namespaceUri);
    if (eventAttribute != null && eventAttribute.isNotEmpty) {
      result = result.copyWith(event: eventAttribute);
    }
    result = result.copyWith(date: metadataDateNode.innerText);
    return result;
  }

  static EpubMetadataIdentifier readMetadataIdentifier(
      XmlElement metadataIdentifierNode) {
    var result = EpubMetadataIdentifier();
    for (var metadataIdentifierNodeAttribute
        in metadataIdentifierNode.attributes) {
      var attributeValue = metadataIdentifierNodeAttribute.value;
      switch (metadataIdentifierNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          result = result.copyWith(id: attributeValue);
          break;
        case 'scheme':
          result = result.copyWith(scheme: attributeValue);
          break;
      }
    }
    result = result.copyWith(identifier: metadataIdentifierNode.innerText);
    return result;
  }

  static EpubMetadataMeta readMetadataMetaVersion2(
      XmlElement metadataMetaNode) {
    var result = EpubMetadataMeta();
    for (var metadataMetaNodeAttribute in metadataMetaNode.attributes) {
      var attributeValue = metadataMetaNodeAttribute.value;
      switch (metadataMetaNodeAttribute.name.local.toLowerCase()) {
        case 'name':
          result = result.copyWith(name: attributeValue);
          break;
        case 'content':
          result = result.copyWith(content: attributeValue);
          break;
      }
    }
    return result;
  }

  static EpubMetadataMeta readMetadataMetaVersion3(
      XmlElement metadataMetaNode) {
    var result = EpubMetadataMeta(attributes: {});
    final newAttributes = <String, String>{};
    for (var metadataMetaNodeAttribute in metadataMetaNode.attributes) {
      var attributeValue = metadataMetaNodeAttribute.value;
      newAttributes[metadataMetaNodeAttribute.name.local.toLowerCase()] =
          attributeValue;
      switch (metadataMetaNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          result = result.copyWith(id: attributeValue);
          break;
        case 'refines':
          result = result.copyWith(refines: attributeValue);
          break;
        case 'property':
          result = result.copyWith(property: attributeValue);
          break;
        case 'scheme':
          result = result.copyWith(scheme: attributeValue);
          break;
      }
    }
    result = result.copyWith(
      content: metadataMetaNode.innerText,
      attributes: newAttributes,
    );
    return result;
  }

  static Future<EpubPackage> readPackage(
      Archive epubArchive, String rootFilePath) async {
    var rootFileEntry = epubArchive.files.firstWhereOrNull(
        (ArchiveFile testFile) => testFile.name == rootFilePath);
    if (rootFileEntry == null) {
      throw Exception('EPUB parsing error: root file not found in archive.');
    }
    var containerDocument =
        XmlDocument.parse(convert.utf8.decode(rootFileEntry.content));
    var opfNamespace = 'http://www.idpf.org/2007/opf';
    var packageNode = containerDocument
        .findElements('package', namespaceUri: opfNamespace)
        .firstWhere((XmlElement? elem) => elem != null);
    var result = EpubPackage();
    var epubVersionValue = packageNode.getAttribute('version');
    if (epubVersionValue == '2.0') {
      result = result.copyWith(version: EpubVersion.Epub2);
    } else if (epubVersionValue == '3.0') {
      result = result.copyWith(version: EpubVersion.Epub3);
    } else {
      throw Exception('Unsupported EPUB version: $epubVersionValue.');
    }
    var metadataNode = packageNode
        .findElements('metadata', namespaceUri: opfNamespace)
        .cast<XmlElement?>()
        .firstWhere((XmlElement? elem) => elem != null);
    if (metadataNode == null) {
      throw Exception('EPUB parsing error: metadata not found in the package.');
    }
    var metadata = readMetadata(metadataNode, result.version);
    result = result.copyWith(metadata: metadata);
    var manifestNode = packageNode
        .findElements('manifest', namespaceUri: opfNamespace)
        .cast<XmlElement?>()
        .firstWhere((XmlElement? elem) => elem != null);
    if (manifestNode == null) {
      throw Exception('EPUB parsing error: manifest not found in the package.');
    }
    var manifest = readManifest(manifestNode);
    result = result.copyWith(manifest: manifest);

    var spineNode = packageNode
        .findElements('spine', namespaceUri: opfNamespace)
        .cast<XmlElement?>()
        .firstWhere((XmlElement? elem) => elem != null);
    if (spineNode == null) {
      throw Exception('EPUB parsing error: spine not found in the package.');
    }
    var spine = readSpine(spineNode);
    result = result.copyWith(spine: spine);
    var guideNode = packageNode
        .findElements('guide', namespaceUri: opfNamespace)
        .firstWhereOrNull((XmlElement? elem) => elem != null);
    if (guideNode != null) {
      var guide = readGuide(guideNode);
      result = result.copyWith(guide: guide);
    }
    return result;
  }

  static EpubSpine readSpine(XmlElement spineNode) {
    var result = EpubSpine(items: []);
    var tocAttribute = spineNode.getAttribute('toc');
    // result.tableOfContents = tocAttribute;
    result = result.copyWith(tableOfContents: tocAttribute);
    var pageProgression = spineNode.getAttribute('page-progression-direction');
    result = result.copyWith(
        ltr: ((pageProgression == null) ||
            pageProgression.toLowerCase() == 'ltr'));
    spineNode.children
        .whereType<XmlElement>()
        .forEach((XmlElement spineItemNode) {
      if (spineItemNode.name.local.toLowerCase() == 'itemref') {
        var spineItemRef = EpubSpineItemRef();
        var idRefAttribute = spineItemNode.getAttribute('idref');
        if (idRefAttribute == null || idRefAttribute.isEmpty) {
          throw Exception('Incorrect EPUB spine: item ID ref is missing');
        }
        spineItemRef = spineItemRef.copyWith(idRef: idRefAttribute);
        var linearAttribute = spineItemNode.getAttribute('linear');
        spineItemRef = spineItemRef.copyWith(
            linear: linearAttribute == null ||
                (linearAttribute.toLowerCase() == 'no'));
        result = result.addItem(spineItemRef);
      }
    });
    return result;
  }
}
