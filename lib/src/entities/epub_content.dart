import 'package:equatable/equatable.dart';

import 'epub_byte_content_file.dart';
import 'epub_content_file.dart';
import 'epub_text_content_file.dart';

class EpubContent extends Equatable {
  final Map<String, EpubTextContentFile> html;
  final Map<String, EpubTextContentFile> css;
  final Map<String, EpubByteContentFile> images;
  final Map<String, EpubByteContentFile> fonts;
  final Map<String, EpubContentFile> allFiles;

  const EpubContent({
    Map<String, EpubTextContentFile>? html,
    Map<String, EpubTextContentFile>? css,
    Map<String, EpubByteContentFile>? images,
    Map<String, EpubByteContentFile>? fonts,
    Map<String, EpubContentFile>? allFiles,
  })  : html = html ?? const <String, EpubTextContentFile>{},
        css = css ?? const <String, EpubTextContentFile>{},
        images = images ?? const <String, EpubByteContentFile>{},
        fonts = fonts ?? const <String, EpubByteContentFile>{},
        allFiles = allFiles ?? const <String, EpubContentFile>{};

  @override
  List<Object?> get props => [html, css, images, fonts, allFiles];
}
