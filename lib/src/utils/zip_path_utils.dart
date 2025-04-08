class ZipPathUtils {
  static String getDirectoryPath(String filePath) {
    var lastSlashIndex = filePath.lastIndexOf('/');
    if (lastSlashIndex == -1) {
      return '';
    } else {
      return filePath.substring(0, lastSlashIndex);
    }
  }

  static String? combine(String? directory, String? fileName) {
    String? path;
    if (directory == null || directory == '') {
      path = fileName;
      // Don't use Uri.parse() which encodes non-ASCII characters
      return path != null ? _normalizePath(path) : null;
    } else {
      return '$directory/${fileName!}';
    }
  }

  // Helper method to normalize path without encoding non-ASCII characters
  static String _normalizePath(String path) {
    // Handle '..' and '.' segments without using Uri.parse()
    List<String> segments = path.split('/');
    List<String> result = [];

    for (String segment in segments) {
      if (segment == '..') {
        if (result.isNotEmpty) {
          result.removeLast();
        }
      } else if (segment != '.' && segment.isNotEmpty) {
        result.add(segment);
      }
    }

    return result.join('/');
  }
}
