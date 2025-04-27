class Utils {
  static String removeQueryParamsFromUrl(String url) {
    if (url.isEmpty) return url;
    Uri uri = Uri.parse(url);
    String newUrl = Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.port,
      path: uri.path,
    ).toString();
    return newUrl;
  }
}
