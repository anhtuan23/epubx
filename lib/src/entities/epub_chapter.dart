import 'package:equatable/equatable.dart';

class EpubChapter extends Equatable {
  final String? title;
  final String? contentFileName;
  final String? anchor;
  final String? htmlContent;
  final List<EpubChapter>? subChapters;
  final List<String> otherContentFileNames;

  EpubChapter({
    this.title,
    this.contentFileName,
    this.anchor,
    this.htmlContent,
    this.subChapters,
    List<String>? otherContentFileNames,
  }) : otherContentFileNames = otherContentFileNames ?? const <String>[];

  @override
  List<Object?> get props => [
        title,
        contentFileName,
        otherContentFileNames,
        anchor,
        htmlContent,
        subChapters
      ];

  @override
  String toString() {
    return 'Title: $title, Subchapter count: ${subChapters?.length ?? 0}';
  }
}
