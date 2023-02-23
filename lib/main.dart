import 'package:context_holder/context_holder.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/utils/waifu_2x_updater.dart';
import '/utils/image_extensions.dart';
import '/utils/globals.dart';
import '/utils/hive.dart';

import '/widgets/preview_window.dart';
import '/widgets/config_panel.dart';
import '/widgets/warning_widgets/waifu2x_warning_widget.dart';
import '/widgets/warning_widgets/loading.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ExtensionAdapter());
  await loadConfig();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: ContextHolder.key,
      title: 'Waifu-Upscaler',
      scaffoldMessengerKey: snackbarKey,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        backgroundColor: Colors.grey[300],
        dialogBackgroundColor: Colors.grey[100],
      ),
      home: const WorkspacePage(title: 'Waifu-Upscaler'),
    );
  }
}

class WorkspacePage extends StatefulWidget {
  const WorkspacePage({super.key, required this.title});

  final String title;

  @override
  State<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends State<WorkspacePage>
    with TickerProviderStateMixin {
  void _asyncInit() async {}

  late Future<bool> waifuExists;

  @override
  void initState() {
    super.initState();
    _asyncInit();
    waifuExists = updateWaifuExeExists();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  Flexible(
                    child: ConfigPanel(width: width),
                  ),
                  FutureBuilder<bool>(
                      future: waifuExists,
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.hasData) {
                          if (!snapshot.data!) {
                            return WaifuNotFoundWidget(
                              width: width,
                              ticker: this,
                              onChanged: (value) => setState(() {
                                waifuExists = updateWaifuExeExists();
                              }),
                            );
                          } else {
                            return SizedBox(height: 0);
                          }
                        } else {
                          return LoadingWidget(width: width);
                        }
                      }),
                ],
              ),
              const Flexible(
                child: PreviewWindow(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
