import 'epub_content_file.dart';

class EpubTextContentFile extends EpubContentFile {
  final String? content;

  const EpubTextContentFile({
    super.fileName,
    super.contentType,
    super.contentMimeType,
    this.content,
  });

  @override
  List<Object?> get props => [...super.props, content];
}
