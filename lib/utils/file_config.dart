library waifu_gui.file_config;

import 'package:path/path.dart';

import '../utils/image_extensions.dart';

class FileConfig {
  String output_folder = '';
  int noise = 0;
  int scale = 2;
  bool tta = false;
  Extension format = Extension(".png");
}

FileConfig fileConfig = FileConfig();
