import '../entities/epub_content_type.dart';
import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_byte_content_file_ref.dart';
import '../ref_entities/epub_content_file_ref.dart';
import '../ref_entities/epub_content_ref.dart';
import '../ref_entities/epub_text_content_file_ref.dart';

class ContentReader {
  static EpubContentRef parseContentMap(EpubBookRef bookRef) {
    var result = EpubContentRef();

    for (var manifestItem in bookRef.schema!.package!.manifest!.items!) {
      var fileName = manifestItem.href;
      var contentMimeType = manifestItem.mediaType!;
      var contentType = getContentTypeByContentMimeType(contentMimeType);
      switch (contentType) {
        case EpubContentType.XHTML_1_1:
        case EpubContentType.CSS:
        case EpubContentType.OEB1_DOCUMENT:
        case EpubContentType.OEB1_CSS:
        case EpubContentType.XML:
        case EpubContentType.DTBOOK:
        case EpubContentType.DTBOOK_NCX:
          var epubTextContentFile = EpubTextContentFileRef(bookRef);
          {
            epubTextContentFile.fileName = Uri.decodeFull(fileName!);
            epubTextContentFile.contentMimeType = contentMimeType;
            epubTextContentFile.contentType = contentType;
          }
          switch (contentType) {
            case EpubContentType.XHTML_1_1:
              result.html[fileName] = epubTextContentFile;
              break;
            case EpubContentType.CSS:
              result.css[fileName] = epubTextContentFile;
              break;
            case EpubContentType.DTBOOK:
            case EpubContentType.DTBOOK_NCX:
            case EpubContentType.OEB1_DOCUMENT:
            case EpubContentType.XML:
            case EpubContentType.OEB1_CSS:
            case EpubContentType.IMAGE_GIF:
            case EpubContentType.IMAGE_JPEG:
            case EpubContentType.IMAGE_PNG:
            case EpubContentType.IMAGE_SVG:
            case EpubContentType.IMAGE_BMP:
            case EpubContentType.FONT_TRUETYPE:
            case EpubContentType.FONT_OPENTYPE:
            case EpubContentType.OTHER:
              break;
          }
          result.allFiles[fileName] = epubTextContentFile;
          break;
        default:
          var epubByteContentFile = EpubByteContentFileRef(bookRef);
          {
            epubByteContentFile.fileName = Uri.decodeFull(fileName!);
            epubByteContentFile.contentMimeType = contentMimeType;
            epubByteContentFile.contentType = contentType;
          }
          switch (contentType) {
            case EpubContentType.IMAGE_GIF:
            case EpubContentType.IMAGE_JPEG:
            case EpubContentType.IMAGE_PNG:
            case EpubContentType.IMAGE_SVG:
            case EpubContentType.IMAGE_BMP:
              result.images[fileName] = epubByteContentFile;
              break;
            case EpubContentType.FONT_TRUETYPE:
            case EpubContentType.FONT_OPENTYPE:
              result.fonts[fileName] = epubByteContentFile;
              break;
            case EpubContentType.CSS:
            case EpubContentType.XHTML_1_1:
            case EpubContentType.DTBOOK:
            case EpubContentType.DTBOOK_NCX:
            case EpubContentType.OEB1_DOCUMENT:
            case EpubContentType.XML:
            case EpubContentType.OEB1_CSS:
            case EpubContentType.OTHER:
              break;
          }
          result.allFiles[fileName] = epubByteContentFile;
          break;
      }
    }
    return result;
  }

  static EpubContentType getContentTypeByContentMimeType(
      String contentMimeType) {
    switch (contentMimeType.toLowerCase()) {
      case 'application/xhtml+xml':
      case 'text/html':
        return EpubContentType.XHTML_1_1;
      case 'application/x-dtbook+xml':
        return EpubContentType.DTBOOK;
      case 'application/x-dtbncx+xml':
        return EpubContentType.DTBOOK_NCX;
      case 'text/x-oeb1-document':
        return EpubContentType.OEB1_DOCUMENT;
      case 'application/xml':
        return EpubContentType.XML;
      case 'text/css':
        return EpubContentType.CSS;
      case 'text/x-oeb1-css':
        return EpubContentType.OEB1_CSS;
      case 'image/gif':
        return EpubContentType.IMAGE_GIF;
      case 'image/jpeg':
        return EpubContentType.IMAGE_JPEG;
      case 'image/png':
        return EpubContentType.IMAGE_PNG;
      case 'image/svg+xml':
        return EpubContentType.IMAGE_SVG;
      case 'image/bmp':
        return EpubContentType.IMAGE_BMP;
      case 'font/truetype':
        return EpubContentType.FONT_TRUETYPE;
      case 'font/opentype':
        return EpubContentType.FONT_OPENTYPE;
      case 'application/vnd.ms-opentype':
        return EpubContentType.FONT_OPENTYPE;
      default:
        return EpubContentType.OTHER;
    }
  }

  /// Creates a minimal valid content reference for fallback when parsing fails
  static EpubContentRef createMinimalContentRef() {
    return EpubContentRef(
      html: <String, EpubTextContentFileRef>{},
      css: <String, EpubTextContentFileRef>{},
      images: <String, EpubByteContentFileRef>{},
      fonts: <String, EpubByteContentFileRef>{},
      allFiles: <String, EpubContentFileRef>{},
    );
  }
}
