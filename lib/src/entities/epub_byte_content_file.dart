import 'epub_content_file.dart';

class EpubByteContentFile extends EpubContentFile {
  final List<int>? content;

  const EpubByteContentFile({
    super.fileName,
    super.contentType,
    super.contentMimeType,
    this.content,
  });

  @override
  List<Object?> get props => [...super.props, content];
}
