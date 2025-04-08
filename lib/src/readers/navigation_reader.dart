import 'dart:async';

import 'package:archive/archive.dart';
import 'dart:convert' as convert;
import 'package:collection/collection.dart' show IterableExtension;
import 'package:epubx/src/schema/opf/epub_version.dart';
import 'package:xml/xml.dart' as xml;
import 'package:path/path.dart' as path;

import '../schema/navigation/epub_metadata.dart';
import '../schema/navigation/epub_navigation.dart';
import '../schema/navigation/epub_navigation_doc_author.dart';
import '../schema/navigation/epub_navigation_doc_title.dart';
import '../schema/navigation/epub_navigation_head.dart';
import '../schema/navigation/epub_navigation_head_meta.dart';
import '../schema/navigation/epub_navigation_label.dart';
import '../schema/navigation/epub_navigation_list.dart';
import '../schema/navigation/epub_navigation_map.dart';
import '../schema/navigation/epub_navigation_page_list.dart';
import '../schema/navigation/epub_navigation_page_target.dart';
import '../schema/navigation/epub_navigation_page_target_type.dart';
import '../schema/navigation/epub_navigation_point.dart';
import '../schema/navigation/epub_navigation_target.dart';
import '../schema/opf/epub_manifest_item.dart';
import '../schema/opf/epub_package.dart';
import '../utils/enum_from_string.dart';
import '../utils/zip_path_utils.dart';

// ignore: omit_local_variable_types

class NavigationReader {
  static String? _tocFileEntryPath;

  static Future<EpubNavigation> readNavigation(Archive epubArchive,
      String contentDirectoryPath, EpubPackage package) async {
    var result = EpubNavigation();
    if (package.version == EpubVersion.Epub2) {
      var tocId = package.spine!.tableOfContents;
      if (tocId == null || tocId.isEmpty) {
        throw Exception('EPUB parsing error: TOC ID is empty.');
      }

      var tocManifestItem =
          package.manifest!.items!.cast<EpubManifestItem?>().firstWhere(
                (EpubManifestItem? item) =>
                    item!.id!.toLowerCase() == tocId.toLowerCase(),
                orElse: () => null,
              );
      if (tocManifestItem == null) {
        throw Exception(
            'EPUB parsing error: TOC item $tocId not found in EPUB manifest.');
      }

      _tocFileEntryPath =
          ZipPathUtils.combine(contentDirectoryPath, tocManifestItem.href);
      var tocFileEntry = epubArchive.files.cast<ArchiveFile?>().firstWhere(
          (ArchiveFile? file) =>
              file!.name.toLowerCase() == _tocFileEntryPath!.toLowerCase(),
          orElse: () => null);
      if (tocFileEntry == null) {
        throw Exception(
            'EPUB parsing error: TOC file $_tocFileEntryPath not found in archive.');
      }

      var containerDocument =
          xml.XmlDocument.parse(convert.utf8.decode(tocFileEntry.content));

      var ncxNamespace = 'http://www.daisy.org/z3986/2005/ncx/';
      var ncxNode = containerDocument
          .findAllElements('ncx', namespace: ncxNamespace)
          .cast<xml.XmlElement?>()
          .firstWhere((xml.XmlElement? elem) => elem != null,
              orElse: () => null);
      if (ncxNode == null) {
        throw Exception(
            'EPUB parsing error: TOC file does not contain ncx element.');
      }

      var headNode = ncxNode
          .findAllElements('head', namespace: ncxNamespace)
          .cast<xml.XmlElement?>()
          .firstWhere((xml.XmlElement? elem) => elem != null,
              orElse: () => null);
      if (headNode == null) {
        throw Exception(
            'EPUB parsing error: TOC file does not contain head element.');
      }

      var navigationHead = readNavigationHead(headNode);
      result = result.copyWith(head: navigationHead);
      var docTitleNode = ncxNode
          .findElements('docTitle', namespace: ncxNamespace)
          .cast<xml.XmlElement?>()
          .firstWhere((xml.XmlElement? elem) => elem != null,
              orElse: () => null);
      if (docTitleNode == null) {
        throw Exception(
            'EPUB parsing error: TOC file does not contain docTitle element.');
      }

      var navigationDocTitle = readNavigationDocTitle(docTitleNode);
      result = result.copyWith(
          docTitle: navigationDocTitle,
          docAuthors: <EpubNavigationDocAuthor>[]);
      ncxNode
          .findElements('docAuthor', namespace: ncxNamespace)
          .forEach((xml.XmlElement docAuthorNode) {
        var navigationDocAuthor = readNavigationDocAuthor(docAuthorNode);
        result.docAuthors!.add(navigationDocAuthor);
      });

      var navMapNode = ncxNode
          .findElements('navMap', namespace: ncxNamespace)
          .cast<xml.XmlElement?>()
          .firstWhere((xml.XmlElement? elem) => elem != null,
              orElse: () => null);
      if (navMapNode == null) {
        throw Exception(
            'EPUB parsing error: TOC file does not contain navMap element.');
      }

      var navMap = readNavigationMap(navMapNode);
      result = result.copyWith(navMap: navMap);
      var pageListNode = ncxNode
          .findElements('pageList', namespace: ncxNamespace)
          .cast<xml.XmlElement?>()
          .firstWhere((xml.XmlElement? elem) => elem != null,
              orElse: () => null);
      if (pageListNode != null) {
        var pageList = readNavigationPageList(pageListNode);
        result = result.copyWith(pageList: pageList);
      }

      result = result.copyWith(navLists: <EpubNavigationList>[]);
      ncxNode
          .findElements('navList', namespace: ncxNamespace)
          .forEach((xml.XmlElement navigationListNode) {
        var navigationList = readNavigationList(navigationListNode);
        result.navLists!.add(navigationList);
      });
    } else {
      //Version 3

      var tocManifestItem = package.manifest!.items!
          .cast<EpubManifestItem?>()
          .firstWhere((element) => element!.properties == 'nav',
              orElse: () => null);
      if (tocManifestItem == null) {
        // Instead of throwing an exception, try to find an item that might be a TOC
        // Common TOC filenames include toc.xhtml, nav.xhtml, etc.
        var possibleTocItems = package.manifest!.items!
            .cast<EpubManifestItem?>()
            .where((element) =>
                element!.href != null &&
                (element.href!.toLowerCase().contains('toc') ||
                    element.href!.toLowerCase().contains('nav') ||
                    element.href!.toLowerCase().contains('contents')) &&
                element.mediaType == 'application/xhtml+xml')
            .toList();

        if (possibleTocItems.isNotEmpty) {
          tocManifestItem = possibleTocItems.first;
          print(
              'Warning: TOC item with "nav" property not found. Using ${tocManifestItem!.href} as fallback.');
        } else {
          // Create a minimal navigation structure
          result = result.copyWith(
              docTitle:
                  EpubNavigationDocTitle(titles: package.metadata!.titles),
              docAuthors: <EpubNavigationDocAuthor>[],
              navMap: EpubNavigationMap(points: <EpubNavigationPoint>[]));
          print(
              'Warning: Could not find TOC item in EPUB manifest. Creating minimal navigation structure.');
          return result;
        }
      }

      _tocFileEntryPath =
          ZipPathUtils.combine(contentDirectoryPath, tocManifestItem.href);
      var tocFileEntry = epubArchive.files.cast<ArchiveFile?>().firstWhere(
          (ArchiveFile? file) =>
              file!.name.toLowerCase() == _tocFileEntryPath!.toLowerCase(),
          orElse: () => null);
      if (tocFileEntry == null) {
        // Instead of throwing an exception, create a minimal navigation structure
        result = result.copyWith(
            docTitle: EpubNavigationDocTitle(titles: package.metadata!.titles),
            docAuthors: <EpubNavigationDocAuthor>[],
            navMap: EpubNavigationMap(points: <EpubNavigationPoint>[]));
        print(
            'Warning: TOC file $_tocFileEntryPath not found in archive. Creating minimal navigation structure.');
        return result;
      }
      //Get relative toc file path
      _tocFileEntryPath =
          '${((_tocFileEntryPath!.split('/')..removeLast())..removeAt(0)).join('/')}/';

      var containerDocument =
          xml.XmlDocument.parse(convert.utf8.decode(tocFileEntry.content));

      var headNode = containerDocument
          .findAllElements('head')
          .cast<xml.XmlElement?>()
          .firstWhere((xml.XmlElement? elem) => elem != null,
              orElse: () => null);
      if (headNode == null) {
        // Try to continue even without a head element
        print('Warning: TOC file does not contain head element.');
      }

      // result.docTitle = EpubNavigationDocTitle();
      // result.docTitle!.titles = package.metadata!.titles;
//      result.DocTitle.Titles.add(headNode.findAllElements("title").firstWhere((element) =>  element != null, orElse: () => null).text.trim());

      // result.docAuthors = <EpubNavigationDocAuthor>[];
      result = result.copyWith(
        docTitle: EpubNavigationDocTitle(titles: package.metadata!.titles),
        docAuthors: <EpubNavigationDocAuthor>[],
      );

      var navNode = containerDocument
          .findAllElements('nav')
          .cast<xml.XmlElement?>()
          .firstWhere((xml.XmlElement? elem) => elem != null,
              orElse: () => null);
      if (navNode == null) {
        // Try to create a simple navigation map
        print(
            'Warning: TOC file does not contain nav element. Creating minimal navigation structure.');
        result = result.copyWith(
            navMap: EpubNavigationMap(points: <EpubNavigationPoint>[]));
        return result;
      }

      var navMapNodes = navNode.findElements('ol').toList();
      if (navMapNodes.isEmpty) {
        // No ol elements found, create minimal navigation structure
        result = result.copyWith(
            navMap: EpubNavigationMap(points: <EpubNavigationPoint>[]));
        return result;
      }

      var navMapNode = navMapNodes.first;

      var navMap = readNavigationMapV3(navMapNode);
      result = result.copyWith(navMap: navMap);

      //TODO : Implement pagesLists
//      xml.XmlElement pageListNode = ncxNode
//          .findElements("pageList", namespace: ncxNamespace)
//          .firstWhere((xml.XmlElement elem) => elem != null,
//          orElse: () => null);
//      if (pageListNode != null) {
//        EpubNavigationPageList pageList = readNavigationPageList(pageListNode);
//        result.PageList = pageList;
//      }
    }

    return result;
  }

  static EpubNavigationContent readNavigationContent(
      xml.XmlElement navigationContentNode) {
    var result = EpubNavigationContent();
    for (var navigationContentNodeAttribute
        in navigationContentNode.attributes) {
      var attributeValue = navigationContentNodeAttribute.value;
      switch (navigationContentNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          result = result.copyWith(id: attributeValue);
          break;
        case 'src':
          result = result.copyWith(source: attributeValue);
          break;
      }
    }
    if (result.source == null || result.source!.isEmpty) {
      throw Exception(
          'Incorrect EPUB navigation content: content source is missing.');
    }

    return result;
  }

  static EpubNavigationContent readNavigationContentV3(
      xml.XmlElement navigationContentNode) {
    var result = EpubNavigationContent();

    // Default to a safe value for source if we don't find one
    result = result.copyWith(source: '#');

    for (var navigationContentNodeAttribute
        in navigationContentNode.attributes) {
      var attributeValue = navigationContentNodeAttribute.value;
      switch (navigationContentNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          result = result.copyWith(id: attributeValue);
          break;
        case 'href':
          if (attributeValue.isEmpty) {
            // Use default safe value for empty href
            print(
                'Warning: Empty href in navigation content, using placeholder.');
          } else if (_tocFileEntryPath == null) {
            // If _tocFileEntryPath is null, use the href directly
            result = result.copyWith(source: attributeValue);
          } else if (_tocFileEntryPath!.length < 2 ||
              attributeValue.startsWith(_tocFileEntryPath!)) {
            result = result.copyWith(source: attributeValue);
          } else {
            try {
              result = result.copyWith(
                  source: path.normalize(_tocFileEntryPath! + attributeValue));
            } catch (e) {
              print('Warning: Error normalizing path: $e');
              // Use the href directly as a fallback
              result = result.copyWith(source: attributeValue);
            }
          }
          break;
      }
    }

    return result;
  }

  static String extractContentPath(String tocFileEntryPath, String ref) {
    if (!tocFileEntryPath.endsWith('/')) {
      tocFileEntryPath = '$tocFileEntryPath/';
    }
    var r = tocFileEntryPath + ref;
    r = r.replaceAll('/./', '/');
    r = r.replaceAll(RegExp(r'/[^/]+/\.\./'), '/');
    r = r.replaceAll(RegExp(r'^[^/]+/\.\./'), '');
    return r;
  }

  static EpubNavigationDocAuthor readNavigationDocAuthor(
      xml.XmlElement docAuthorNode) {
    var result = EpubNavigationDocAuthor(authors: <String>[]);
    docAuthorNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement textNode) {
      if (textNode.name.local.toLowerCase() == 'text') {
        result.authors!.add(textNode.innerText);
      }
    });
    return result;
  }

  static EpubNavigationDocTitle readNavigationDocTitle(
      xml.XmlElement docTitleNode) {
    var result = EpubNavigationDocTitle(
      titles: <String>[],
    );
    docTitleNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement textNode) {
      if (textNode.name.local.toLowerCase() == 'text') {
        result.titles!.add(textNode.innerText);
      }
    });
    return result;
  }

  static EpubNavigationHead readNavigationHead(xml.XmlElement headNode) {
    var result = EpubNavigationHead(
      metadata: <EpubNavigationHeadMeta>[],
    );

    headNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement metaNode) {
      if (metaNode.name.local.toLowerCase() == 'meta') {
        var meta = EpubNavigationHeadMeta();
        for (var metaNodeAttribute in metaNode.attributes) {
          var attributeValue = metaNodeAttribute.value;
          switch (metaNodeAttribute.name.local.toLowerCase()) {
            case 'name':
              meta = meta.copyWith(name: attributeValue);
              break;
            case 'content':
              meta = meta.copyWith(content: attributeValue);
              break;
            case 'scheme':
              meta = meta.copyWith(scheme: attributeValue);
              break;
          }
        }

        if (meta.name == null || meta.name!.isEmpty) {
          throw Exception(
              'Incorrect EPUB navigation meta: meta name is missing.');
        }
        if (meta.content == null) {
          throw Exception(
              'Incorrect EPUB navigation meta: meta content is missing.');
        }

        result.metadata!.add(meta);
      }
    });
    return result;
  }

  static EpubNavigationLabel readNavigationLabel(
      xml.XmlElement navigationLabelNode) {
    var result = EpubNavigationLabel();

    var navigationLabelTextNode = navigationLabelNode
        .findElements('text', namespace: navigationLabelNode.name.namespaceUri)
        .firstWhereOrNull((xml.XmlElement? elem) => elem != null);
    if (navigationLabelTextNode == null) {
      throw Exception(
          'Incorrect EPUB navigation label: label text element is missing.');
    }

    result = result.copyWith(
      text: navigationLabelTextNode.innerText,
    );

    return result;
  }

  static EpubNavigationLabel readNavigationLabelV3(
      xml.XmlElement navigationLabelNode) {
    var result =
        EpubNavigationLabel(text: navigationLabelNode.innerText.trim());
    return result;
  }

  static EpubNavigationList readNavigationList(
      xml.XmlElement navigationListNode) {
    var result = EpubNavigationList();
    for (var navigationListNodeAttribute in navigationListNode.attributes) {
      var attributeValue = navigationListNodeAttribute.value;
      switch (navigationListNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          result = result.copyWith(id: attributeValue);
          break;
        case 'class':
          result = result.copyWith(className: attributeValue);
          break;
      }
    }
    navigationListNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationListChildNode) {
      switch (navigationListChildNode.name.local.toLowerCase()) {
        case 'navlabel':
          var navigationLabel = readNavigationLabel(navigationListChildNode);
          result.navigationLabels!.add(navigationLabel);
          break;
        case 'navtarget':
          var navigationTarget = readNavigationTarget(navigationListChildNode);
          result.navigationTargets!.add(navigationTarget);
          break;
      }
    });
    // if (result.NavigationLabels!.isEmpty) {
    //   throw Exception(
    //       'Incorrect EPUB navigation page target: at least one navLabel element is required.');
    // }
    return result;
  }

  static EpubNavigationMap readNavigationMap(xml.XmlElement navigationMapNode) {
    var result = EpubNavigationMap(
      points: <EpubNavigationPoint>[],
    );
    navigationMapNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationPointNode) {
      if (navigationPointNode.name.local.toLowerCase() == 'navpoint') {
        var navigationPoint = readNavigationPoint(navigationPointNode);
        result.points!.add(navigationPoint);
      }
    });
    return result;
  }

  static EpubNavigationMap readNavigationMapV3(
      xml.XmlElement navigationMapNode) {
    var result = EpubNavigationMap(
      points: <EpubNavigationPoint>[],
    );
    navigationMapNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationPointNode) {
      if (navigationPointNode.name.local.toLowerCase() == 'li') {
        var navigationPoint = readNavigationPointV3(navigationPointNode);
        result.points!.add(navigationPoint);
      }
    });
    return result;
  }

  static EpubNavigationPageList readNavigationPageList(
      xml.XmlElement navigationPageListNode) {
    var result =
        EpubNavigationPageList(pageTargets: <EpubNavigationPageTarget>[]);
    navigationPageListNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement pageTargetNode) {
      if (pageTargetNode.name.local == 'pageTarget') {
        var pageTarget = readNavigationPageTarget(pageTargetNode);
        result.addPageTarget(pageTarget);
      }
    });

    return result;
  }

  static EpubNavigationPageTarget readNavigationPageTarget(
      xml.XmlElement navigationPageTargetNode) {
    var result = EpubNavigationPageTarget(
      navigationLabels: <EpubNavigationLabel>[],
    );
    for (var navigationPageTargetNodeAttribute
        in navigationPageTargetNode.attributes) {
      var attributeValue = navigationPageTargetNodeAttribute.value;
      switch (navigationPageTargetNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          result = result.copyWith(id: attributeValue);
          break;
        case 'value':
          result = result.copyWith(value: attributeValue);
          break;
        case 'type':
          var converter = EnumFromString<EpubNavigationPageTargetType>(
              EpubNavigationPageTargetType.values);
          var type = converter.get(attributeValue);
          result = result.copyWith(type: type);
          break;
        case 'class':
          result = result.copyWith(className: attributeValue);
          break;
        case 'playorder':
          result = result.copyWith(playOrder: attributeValue);
          break;
      }
    }
    if (result.type == EpubNavigationPageTargetType.UNDEFINED) {
      throw Exception(
          'Incorrect EPUB navigation page target: page target type is missing.');
    }

    navigationPageTargetNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationPageTargetChildNode) {
      switch (navigationPageTargetChildNode.name.local.toLowerCase()) {
        case 'navlabel':
          var navigationLabel =
              readNavigationLabel(navigationPageTargetChildNode);
          result.navigationLabels!.add(navigationLabel);
          break;
        case 'content':
          var content = readNavigationContent(navigationPageTargetChildNode);
          // result.content = content;
          result = result.copyWith(content: content);
          break;
      }
    });
    if (result.navigationLabels!.isEmpty) {
      throw Exception(
          'Incorrect EPUB navigation page target: at least one navLabel element is required.');
    }

    return result;
  }

  static EpubNavigationPoint readNavigationPoint(
      xml.XmlElement navigationPointNode) {
    var result = EpubNavigationPoint();
    for (var navigationPointNodeAttribute in navigationPointNode.attributes) {
      var attributeValue = navigationPointNodeAttribute.value;
      switch (navigationPointNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          result = result.copyWith(id: attributeValue);
          break;
        case 'class':
          result = result.copyWith(className: attributeValue);
          break;
        case 'playorder':
          result = result.copyWith(playOrder: attributeValue);
          break;
      }
    }
    if (result.id == null || result.id!.isEmpty) {
      throw Exception('Incorrect EPUB navigation point: point ID is missing.');
    }

    result = result.copyWith(
      navigationLabels: <EpubNavigationLabel>[],
      childNavigationPoints: <EpubNavigationPoint>[],
    );
    navigationPointNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationPointChildNode) {
      switch (navigationPointChildNode.name.local.toLowerCase()) {
        case 'navlabel':
          var navigationLabel = readNavigationLabel(navigationPointChildNode);
          result.navigationLabels!.add(navigationLabel);
          break;
        case 'content':
          var content = readNavigationContent(navigationPointChildNode);
          result = result.copyWith(content: content);
          break;
        case 'navpoint':
          var childNavigationPoint =
              readNavigationPoint(navigationPointChildNode);
          result.childNavigationPoints!.add(childNavigationPoint);
          break;
      }
    });

    if (result.navigationLabels!.isEmpty) {
      throw Exception(
          'EPUB parsing error: navigation point ${result.id} should contain at least one navigation label.');
    }
    if (result.content == null) {
      throw Exception(
          'EPUB parsing error: navigation point ${result.id} should contain content.');
    }

    return result;
  }

  static EpubNavigationPoint readNavigationPointV3(
      xml.XmlElement navigationPointNode) {
    var result = EpubNavigationPoint(
      navigationLabels: <EpubNavigationLabel>[],
      childNavigationPoints: <EpubNavigationPoint>[],
    );

    bool hasContent = false;
    bool hasLabel = false;

    navigationPointNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationPointChildNode) {
      switch (navigationPointChildNode.name.local.toLowerCase()) {
        case 'a':
        case 'span':
          try {
            var navigationLabel =
                readNavigationLabelV3(navigationPointChildNode);
            result.navigationLabels!.add(navigationLabel);
            hasLabel = true;

            // Try to read content but don't fail if we can't
            try {
              var content = readNavigationContentV3(navigationPointChildNode);
              if (content.source != null) {
                result = result.copyWith(content: content);
                hasContent = true;
              }
            } catch (e) {
              print('Warning: Failed to read navigation content: $e');
            }
          } catch (e) {
            print('Warning: Failed to read navigation label: $e');
          }
          break;
        case 'ol':
          try {
            var navMap = readNavigationMapV3(navigationPointChildNode);
            if (navMap.points != null) {
              for (var point in navMap.points!) {
                result.childNavigationPoints!.add(point);
              }
            }
          } catch (e) {
            print('Warning: Failed to read nested navigation points: $e');
          }
          break;
      }
    });

    // If we don't have a label, create a default one
    if (!hasLabel) {
      result.navigationLabels!.add(EpubNavigationLabel(text: 'Untitled'));
    }

    // If we don't have content, create a placeholder
    if (!hasContent) {
      result = result.copyWith(content: EpubNavigationContent(source: '#'));
    }

    return result;
  }

  static EpubNavigationTarget readNavigationTarget(
      xml.XmlElement navigationTargetNode) {
    var result = EpubNavigationTarget();
    for (var navigationPageTargetNodeAttribute
        in navigationTargetNode.attributes) {
      var attributeValue = navigationPageTargetNodeAttribute.value;
      switch (navigationPageTargetNodeAttribute.name.local.toLowerCase()) {
        case 'id':
          // result.iId = attributeValue;
          result = result.copyWith(id: attributeValue);
          break;
        case 'value':
          result = result.copyWith(value: attributeValue);
          break;
        case 'class':
          result = result.copyWith(className: attributeValue);
          break;
        case 'playorder':
          result = result.copyWith(playOrder: attributeValue);
          break;
      }
    }
    if (result.id == null || result.id!.isEmpty) {
      throw Exception(
          'Incorrect EPUB navigation target: navigation target ID is missing.');
    }

    navigationTargetNode.children
        .whereType<xml.XmlElement>()
        .forEach((xml.XmlElement navigationTargetChildNode) {
      switch (navigationTargetChildNode.name.local.toLowerCase()) {
        case 'navlabel':
          var navigationLabel = readNavigationLabel(navigationTargetChildNode);
          result.navigationLabels!.add(navigationLabel);
          break;
        case 'content':
          var content = readNavigationContent(navigationTargetChildNode);
          result = result.copyWith(content: content);
          break;
      }
    });
    if (result.navigationLabels!.isEmpty) {
      throw Exception(
          'Incorrect EPUB navigation target: at least one navLabel element is required.');
    }

    return result;
  }
}
