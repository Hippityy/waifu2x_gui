import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:waifu_gui/utils/file_config.dart';
import 'package:waifu_gui/utils/image_extensions.dart';

final String directory = Directory.current.path;

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

FileConfig fileConfig = FileConfig();

List<Extension> supportedExtensions = [];

List<XFile> importedFilesList = [];
