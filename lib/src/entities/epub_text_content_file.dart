import 'epub_content_file.dart';
import 'epub_content_type.dart';

class EpubTextContentFile extends EpubContentFile {
  final String? content;

  const EpubTextContentFile({
    String? fileName,
    EpubContentType? contentType,
    String? contentMimeType,
    this.content,
  }) : super(
          fileName: fileName,
          contentType: contentType,
          contentMimeType: contentMimeType,
        );

  @override
  List<Object?> get props => [...super.props, content];
}
