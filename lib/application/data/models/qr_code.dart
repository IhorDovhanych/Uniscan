class QrCode {
  String name, url;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  RegExp urlRegex = RegExp(
    r'^(?:http|https):\/\/(?:www\.)?[a-zA-Z0-9\-\._]+(?:\.[a-zA-Z]{2,})+(?:\/[^\s]*)?$'
  );
  QrCode({required this.name, required this.url}){
    if (!isValidUrl(url)) {
      throw ArgumentError('Invalid URL: $url');
    }
  }

  bool isValidUrl(String url) {
  return urlRegex.hasMatch(url);
}
}