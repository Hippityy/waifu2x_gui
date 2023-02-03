library waifu_gui.image_extensions;

List<Extension> supportedExtensions = [];

//https://stackoverflow.com/questions/58237643/how-to-encode-and-decode-a-list-of-custom-objects-to-and-from-json-in-dart
class Extension {
  String extension = "";
  bool native = false;
  String method = "";

  Extension(this.extension) {
    try {
      final Extension ex =
          supportedExtensions.firstWhere((e) => e.extension == extension);
      native = ex.native;
      method = ex.method;
    } on StateError catch (e) {
      extension = "";
      native = false;
      method = "";
    }
  }

  Extension.fromJson(Map<String, dynamic> json) {
    extension = json['extension'];
    native = json['native'];
    method = json['method'];
  }
}
