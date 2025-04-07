import 'package:image/image.dart';
import 'package:equatable/equatable.dart';

import 'epub_chapter.dart';
import 'epub_content.dart';
import 'epub_schema.dart';

class EpubBook extends Equatable {
  final String? title;
  final String? author;
  final List<String?>? authorList;
  final EpubSchema? schema;
  final EpubContent? content;
  final Image? coverImage;
  final List<EpubChapter>? chapters;

  const EpubBook({
    this.title,
    this.author,
    this.authorList,
    this.schema,
    this.content,
    this.coverImage,
    this.chapters,
  });

  @override
  List<Object?> get props => [
        title,
        author,
        authorList,
        schema,
        content,
        coverImage?.getBytes(),
        chapters,
      ];
}
