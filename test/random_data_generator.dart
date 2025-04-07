import 'dart:math' show Random;

import 'package:epubx/epubx.dart';
import 'package:epubx/src/schema/navigation/epub_navigation_target.dart';
import 'package:epubx/src/schema/opf/epub_metadata_contributor.dart';
import 'package:epubx/src/schema/opf/epub_metadata_date.dart';
import 'package:epubx/src/schema/opf/epub_metadata_identifier.dart';
import 'package:epubx/src/schema/opf/epub_metadata_meta.dart';

class RandomString {
  final Random rng;

  RandomString(this.rng);

  static const ASCII_START = 33;
  static const ASCII_END = 126;
  static const NUMERIC_START = 48;
  static const NUMERIC_END = 57;
  static const LOWER_ALPHA_START = 97;
  static const LOWER_ALPHA_END = 122;
  static const UPPER_ALPHA_START = 65;
  static const UPPER_ALPHA_END = 90;

  /// Generates a random integer where [from] <= [to].
  int randomBetween(int from, int to) {
    if (from > to) throw Exception('$from is not > $to');
    return ((to - from) * rng.nextDouble()).toInt() + from;
  }

  /// Generates a random string of [length] with characters
  /// between ascii [from] to [to].
  /// Defaults to characters of ascii '!' to '~'.
  String randomString(int length,
      {int from = ASCII_START, int to = ASCII_END}) {
    return String.fromCharCodes(
        List.generate(length, (index) => randomBetween(from, to)));
  }

  /// Generates a random string of [length] with only numeric characters.
  String randomNumeric(int length) =>
      randomString(length, from: NUMERIC_START, to: NUMERIC_END);

  /// Generates a random string of [length] with only alpha characters.
  String randomAlpha(int length) {
    var lowerAlphaLength = randomBetween(0, length);
    var upperAlphaLength = length - lowerAlphaLength;
    var lowerAlpha = randomString(lowerAlphaLength,
        from: LOWER_ALPHA_START, to: LOWER_ALPHA_END);
    var upperAlpha = randomString(upperAlphaLength,
        from: UPPER_ALPHA_START, to: UPPER_ALPHA_END);
    return randomMerge(lowerAlpha, upperAlpha);
  }

  /// Generates a random string of [length] with alpha-numeric characters.
  String randomAlphaNumeric(int length) {
    var alphaLength = randomBetween(0, length);
    var numericLength = length - alphaLength;
    var alpha = randomAlpha(alphaLength);
    var numeric = randomNumeric(numericLength);
    return randomMerge(alpha, numeric);
  }

  /// Merge [a] with [b] and scramble characters.
  String randomMerge(String a, String b) {
    List<int> mergedCodeUnits = List.from("$a$b".codeUnits);
    mergedCodeUnits.shuffle(rng);
    return String.fromCharCodes(mergedCodeUnits);
  }
}

class RandomDataGenerator {
  final Random rng;
  final RandomString _randomString;
  final int _length;

  RandomDataGenerator(this.rng, this._length)
      : _randomString = RandomString(rng);

  String randomString() {
    return _randomString.randomAlphaNumeric(_length);
  }

  EpubNavigationPoint randomEpubNavigationPoint([int depth = 0]) {
    return EpubNavigationPoint(
      id: randomString(),
      className: randomString(),
      playOrder: randomString(),
      navigationLabels: [randomEpubNavigationLabel()],
      content: randomEpubNavigationContent(),
      childNavigationPoints: depth > 0
          ? [randomEpubNavigationPoint(depth - 1)]
          : <EpubNavigationPoint>[],
    );
  }

  EpubNavigationContent randomEpubNavigationContent() {
    return EpubNavigationContent(id: randomString(), source: randomString());
  }

  EpubNavigationTarget randomEpubNavigationTarget() {
    return EpubNavigationTarget(
      id: randomString(),
      className: randomString(),
      playOrder: randomString(),
      content: randomEpubNavigationContent(),
      navigationLabels: [randomEpubNavigationLabel()],
      value: randomString(),
    );
  }

  EpubNavigationLabel randomEpubNavigationLabel() {
    return EpubNavigationLabel(text: randomString());
  }

  EpubNavigationHead randomEpubNavigationHead() {
    return EpubNavigationHead(metadata: [randomNavigationHeadMeta()]);
  }

  EpubNavigationHeadMeta randomNavigationHeadMeta() {
    return EpubNavigationHeadMeta(
      content: randomString(),
      name: randomString(),
      scheme: randomString(),
    );
  }

  EpubNavigationDocTitle randomNavigationDocTitle() {
    return EpubNavigationDocTitle(titles: [randomString()]);
  }

  EpubNavigationDocAuthor randomNavigationDocAuthor() {
    return EpubNavigationDocAuthor(authors: [randomString()]);
  }

  EpubPackage randomEpubPackage(EpubVersion? version) {
    return EpubPackage(
      guide: randomEpubGuide(),
      manifest: randomEpubManifest(),
      metadata: randomEpubMetadata(),
      spine: randomEpubSpine(),
      version:
          version ?? (rng.nextBool() ? EpubVersion.Epub2 : EpubVersion.Epub3),
    );
  }

  EpubSpine randomEpubSpine() {
    return EpubSpine(
        items: [randomEpubSpineItemRef()],
        tableOfContents: _randomString.randomAlpha(_length));
  }

  EpubSpineItemRef randomEpubSpineItemRef() {
    return EpubSpineItemRef(
        idRef: _randomString.randomAlpha(_length), linear: rng.nextBool());
  }

  EpubManifest randomEpubManifest() {
    return EpubManifest(items: [randomEpubManifestItem()]);
  }

  EpubManifestItem randomEpubManifestItem() {
    return EpubManifestItem(
        fallback: _randomString.randomAlpha(_length),
        fallbackStyle: _randomString.randomAlpha(_length),
        href: _randomString.randomAlpha(_length),
        id: _randomString.randomAlpha(_length),
        mediaType: _randomString.randomAlpha(_length),
        requiredModules: _randomString.randomAlpha(_length),
        requiredNamespace: _randomString.randomAlpha(_length));
  }

  EpubGuide randomEpubGuide() {
    return EpubGuide(items: [randomEpubGuideReference()]);
  }

  EpubGuideReference randomEpubGuideReference() {
    return EpubGuideReference(
        href: _randomString.randomAlpha(_length),
        title: _randomString.randomAlpha(_length),
        type: _randomString.randomAlpha(_length));
  }

  EpubMetadata randomEpubMetadata() {
    return EpubMetadata(
        contributors: [randomEpubMetadataContributor()],
        coverages: [_randomString.randomAlpha(_length)],
        creators: [randomEpubMetadataCreator()],
        dates: [randomEpubMetadataDate()],
        description: _randomString.randomAlpha(_length),
        formats: [_randomString.randomAlpha(_length)],
        identifiers: [randomEpubMetadataIdentifier()],
        languages: [_randomString.randomAlpha(_length)],
        metaItems: [randomEpubMetadataMeta()],
        publishers: [_randomString.randomAlpha(_length)],
        relations: [_randomString.randomAlpha(_length)],
        rights: [_randomString.randomAlpha(_length)],
        sources: [_randomString.randomAlpha(_length)],
        subjects: [_randomString.randomAlpha(_length)],
        titles: [_randomString.randomAlpha(_length)],
        types: [_randomString.randomAlpha(_length)]);
  }

  EpubMetadataMeta randomEpubMetadataMeta() {
    return EpubMetadataMeta(
        content: _randomString.randomAlpha(_length),
        id: _randomString.randomAlpha(_length),
        name: _randomString.randomAlpha(_length),
        property: _randomString.randomAlpha(_length),
        refines: _randomString.randomAlpha(_length),
        scheme: _randomString.randomAlpha(_length));
  }

  EpubMetadataIdentifier randomEpubMetadataIdentifier() {
    return EpubMetadataIdentifier(
        id: _randomString.randomAlpha(_length),
        identifier: _randomString.randomAlpha(_length),
        scheme: _randomString.randomAlpha(_length));
  }

  EpubMetadataDate randomEpubMetadataDate() {
    return EpubMetadataDate(
        date: _randomString.randomAlpha(_length),
        event: _randomString.randomAlpha(_length));
  }

  EpubMetadataContributor randomEpubMetadataContributor() {
    return EpubMetadataContributor(
        contributor: _randomString.randomAlpha(_length),
        fileAs: _randomString.randomAlpha(_length),
        role: _randomString.randomAlpha(_length));
  }

  EpubMetadataCreator randomEpubMetadataCreator() {
    return EpubMetadataCreator(
        creator: _randomString.randomAlpha(_length),
        fileAs: _randomString.randomAlpha(_length),
        role: _randomString.randomAlpha(_length));
  }
}
