import 'package:equatable/equatable.dart';

import 'epub_content_type.dart';

abstract class EpubContentFile extends Equatable {
  final String? fileName;
  final EpubContentType? contentType;
  final String? contentMimeType;

  const EpubContentFile({
    this.fileName,
    this.contentType,
    this.contentMimeType,
  });

  @override
  List<Object?> get props => [fileName, contentType, contentMimeType];
}
