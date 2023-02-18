import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import '/utils/file_config.dart';
import '/utils/config.dart';
import '/utils/image_extensions.dart';

final String directory = Directory.current.path;

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

FileConfig fileConfig = FileConfig();

List<Extension> supportedExtensions = [];

List<XFile> importedFilesList = [];

bool waifuExeExists = false;

Config config = Config();
