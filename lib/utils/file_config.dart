library waifu_gui.file_config;

import 'package:path/path.dart';

import '../utils/image_extensions.dart';

class FileConfig {
  String output_path = '';
  String output_name = '';
  int noise = 0;
  int scale = 2;
  bool tta = false;
  Extension extension = Extension(".png");
}

FileConfig fileConfig = FileConfig();
