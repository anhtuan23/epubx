import 'package:equatable/equatable.dart';

import 'epub_byte_content_file_ref.dart';
import 'epub_content_file_ref.dart';
import 'epub_text_content_file_ref.dart';

class EpubContentRef extends Equatable {
  final Map<String, EpubTextContentFileRef> html;
  final Map<String, EpubTextContentFileRef> css;
  final Map<String, EpubByteContentFileRef> images;
  final Map<String, EpubByteContentFileRef> fonts;
  final Map<String, EpubContentFileRef> allFiles;

  EpubContentRef({
    Map<String, EpubTextContentFileRef>? html,
    Map<String, EpubTextContentFileRef>? css,
    Map<String, EpubByteContentFileRef>? images,
    Map<String, EpubByteContentFileRef>? fonts,
    Map<String, EpubContentFileRef>? allFiles,
  })  : html = html ?? <String, EpubTextContentFileRef>{},
        css = css ?? <String, EpubTextContentFileRef>{},
        images = images ?? <String, EpubByteContentFileRef>{},
        fonts = fonts ?? <String, EpubByteContentFileRef>{},
        allFiles = allFiles ?? <String, EpubContentFileRef>{};

  @override
  List<Object?> get props => [html, css, images, fonts, allFiles];
}
