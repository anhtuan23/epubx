import 'epub_content_file.dart';
import 'epub_content_type.dart';

class EpubByteContentFile extends EpubContentFile {
  final List<int>? content;

  const EpubByteContentFile({
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
