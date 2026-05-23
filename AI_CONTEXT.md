# Epubx Context

Last researched: 2026-05-23.

## Role

`epubx` reads and writes EPUB files. Readdict uses it for importing EPUB books,
reading metadata, extracting content, and laying out book chapters.

## Package Shape

- Package name: `epubx`.
- Current version: `4.0.1`.
- Dart SDK constraint: `>=3.0.0 <4.0.0`.
- Lints: `package:lints/recommended.yaml` with local relaxations.
- Public library: `lib/epubx.dart`.
- Main implementation folders:
  - `lib/src/entities/`: in-memory EPUB book/content models.
  - `lib/src/ref_entities/`: lazy/reference-backed EPUB models.
  - `lib/src/readers/`: content and schema readers.
  - `lib/src/writers/`: EPUB package and archive writers.
  - `lib/src/schema/opf/` and `lib/src/schema/navigation/`: EPUB schema models.
  - `lib/src/utils/`: enum and ZIP path utilities.

## Core Flow

- `EpubReader.openBook` decodes a ZIP archive, reads schema metadata, fills
  title/author/content references, and returns an `EpubBookRef`.
- `EpubReader.readBook` opens the book, loads content files, cover image, and
  chapters, then returns an eager `EpubBook`.
- `EpubReader.readContent` converts referenced HTML, CSS, images, fonts, and
  remaining files into an `EpubContent`.
- `EpubWriter.writeBook` creates a ZIP archive from an `EpubBook`, writes
  `mimetype`, container XML, content files, and OPF package data.

## Modernization Guidance

- Dependency modernization on 2026-05-23 moved this package to current Dart 3
  compatible constraints: `archive ^4.0.9`, `xml ^6.6.1`,
  `image >=4.3.0 <4.9.0`, `collection ^1.19.1`, `path ^1.9.1`,
  `equatable ^2.0.8`, `test ^1.31.1`, and `lints ^6.1.0`.
- `xml` stays on the 6.6 line because `image` versions before 4.9.0 depend on
  XML 6, while image 4.9.x requires a newer `meta` than the active Flutter SDK
  pins through `flutter_test`.
- archive 4 exposes `ArchiveFile.content` as non-null. Missing EPUB manifest
  entries are checked before content stream copying in
  `EpubContentFileRef.getContentFileEntry()`.
- The old `test/epub_image_test.dart` depended on an untracked local EPUB
  fixture named `MY VAMPIRE SYSTEM (JKSManga) (Z-Library).epub`; it was removed
  during modernization because the repository could not validate it.
- The `alicesAdventuresUnderGround.epub` writer round-trip test is a useful
  regression check for OPF metadata and spine parsing. The 2026-05-23 upgrade
  fixed two reader bugs it exposed: `EpubMetadata.copyWith` must preserve
  existing values, and EPUB spine `linear` is true unless the attribute is
  explicitly `no`.

## Tests And Fixtures

- Tests cover entities, reference entities, reader/writer behavior, image
  handling, enum parsing, OPF schema models, and navigation schema models.
- EPUB fixtures live under `test/res/`, including multiple standard EPUB sample
  files under `test/res/std/`.
- Example projects exist under `example/`, including Dart, Flutter, and web
  examples.

## Validation

Run from `epubx/`:

- `dart pub get`
- `dart format .`
- `dart analyze`
- `dart test`
