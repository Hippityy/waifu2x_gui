library waifu_gui.image_extensions;

import 'package:waifu_gui/utils/globals.dart';

//https://stackoverflow.com/questions/58237643/how-to-encode-and-decode-a-list-of-custom-objects-to-and-from-json-in-dart
class Extension {
  String string = "";
  bool native = false;
  String method = "";

  Extension(this.string) {
    try {
      final Extension ex =
          supportedExtensions.firstWhere((e) => e.string == string);
      native = ex.native;
      method = ex.method;
    } on StateError catch (e) {
      string = "";
      native = false;
      method = "";
    }
  }

  Extension.fromJson(Map<String, dynamic> json) {
    string = json['extension'];
    native = json['native'];
    method = json['method'];
  }
}
