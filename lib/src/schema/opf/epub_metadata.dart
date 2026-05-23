import 'package:equatable/equatable.dart';

import 'epub_metadata_contributor.dart';
import 'epub_metadata_creator.dart';
import 'epub_metadata_date.dart';
import 'epub_metadata_identifier.dart';
import 'epub_metadata_meta.dart';

class EpubMetadata extends Equatable {
  EpubMetadata({
    this.titles,
    this.creators,
    this.subjects,
    this.description,
    this.publishers,
    this.contributors,
    this.dates,
    this.types,
    this.formats,
    this.identifiers,
    this.sources,
    this.languages,
    this.relations,
    this.coverages,
    this.rights,
    this.metaItems,
  });

  final List<String>? titles;
  final List<EpubMetadataCreator>? creators;
  final List<String>? subjects;
  final String? description;
  final List<String>? publishers;
  final List<EpubMetadataContributor>? contributors;
  final List<EpubMetadataDate>? dates;
  final List<String>? types;
  final List<String>? formats;
  final List<EpubMetadataIdentifier>? identifiers;
  final List<String>? sources;
  final List<String>? languages;
  final List<String>? relations;
  final List<String>? coverages;
  final List<String>? rights;
  final List<EpubMetadataMeta>? metaItems;

  /// Creates a copy of this [EpubMetadata] but with the given fields replaced with the new values.
  EpubMetadata copyWith({
    List<String>? titles,
    List<EpubMetadataCreator>? creators,
    List<String>? subjects,
    String? description,
    List<String>? publishers,
    List<EpubMetadataContributor>? contributors,
    List<EpubMetadataDate>? dates,
    List<String>? types,
    List<String>? formats,
    List<EpubMetadataIdentifier>? identifiers,
    List<String>? sources,
    List<String>? languages,
    List<String>? relations,
    List<String>? coverages,
    List<String>? rights,
    List<EpubMetadataMeta>? metaItems,
  }) {
    return EpubMetadata(
      titles: titles ?? this.titles,
      creators: creators ?? this.creators,
      subjects: subjects ?? this.subjects,
      description: description ?? this.description,
      publishers: publishers ?? this.publishers,
      contributors: contributors ?? this.contributors,
      dates: dates ?? this.dates,
      types: types ?? this.types,
      formats: formats ?? this.formats,
      identifiers: identifiers ?? this.identifiers,
      sources: sources ?? this.sources,
      languages: languages ?? this.languages,
      relations: relations ?? this.relations,
      coverages: coverages ?? this.coverages,
      rights: rights ?? this.rights,
      metaItems: metaItems ?? this.metaItems,
    );
  }

  /// Adds items to the corresponding lists in this [EpubMetadata].
  EpubMetadata addItem({
    String? title,
    EpubMetadataCreator? creator,
    String? subject,
    String? publisher,
    EpubMetadataContributor? contributor,
    EpubMetadataDate? date,
    String? type,
    String? format,
    EpubMetadataIdentifier? identifier,
    String? source,
    String? language,
    String? relation,
    String? coverage,
    String? right,
    EpubMetadataMeta? metaItem,
  }) {
    return EpubMetadata(
      titles: title != null ? [...?titles, title] : titles,
      creators: creator != null ? [...?creators, creator] : creators,
      subjects: subject != null ? [...?subjects, subject] : subjects,
      description: description,
      publishers: publisher != null ? [...?publishers, publisher] : publishers,
      contributors:
          contributor != null ? [...?contributors, contributor] : contributors,
      dates: date != null ? [...?dates, date] : dates,
      types: type != null ? [...?types, type] : types,
      formats: format != null ? [...?formats, format] : formats,
      identifiers:
          identifier != null ? [...?identifiers, identifier] : identifiers,
      sources: source != null ? [...?sources, source] : sources,
      languages: language != null ? [...?languages, language] : languages,
      relations: relation != null ? [...?relations, relation] : relations,
      coverages: coverage != null ? [...?coverages, coverage] : coverages,
      rights: right != null ? [...?rights, right] : rights,
      metaItems: metaItem != null ? [...?metaItems, metaItem] : metaItems,
    );
  }

  @override
  List<Object?> get props => [
        titles,
        creators,
        subjects,
        description,
        publishers,
        contributors,
        dates,
        types,
        formats,
        identifiers,
        sources,
        languages,
        relations,
        coverages,
        rights,
        metaItems,
      ];
}
