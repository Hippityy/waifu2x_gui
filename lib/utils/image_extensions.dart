library waifu_gui.image_extensions;

import 'package:hive/hive.dart';
import 'package:waifu_gui/utils/globals.dart';

//https://stackoverflow.com/questions/58237643/how-to-encode-and-decode-a-list-of-custom-objects-to-and-from-json-in-dart
class Extension {
  String string = "";
  bool native = false;
  String method = "";
  bool valid = false;

  Extension(this.string) {
    try {
      final Extension ex =
          supportedExtensions.firstWhere((e) => e.string == string);
      native = ex.native;
      method = ex.method;
      valid = true;
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

class ExtensionAdapter extends TypeAdapter<Extension> {
  @override
  final typeId = 0;

  @override
  Extension read(BinaryReader reader) {
    return Extension(reader.read());
  }

  @override
  void write(BinaryWriter writer, Extension data) {
    writer.write(data.string);
  }
}
