import 'package:context_holder/context_holder.dart';
import 'package:flutter/material.dart';
import 'package:waifu_gui/utils/config.dart';
import 'widgets/preview_window.dart';
import 'widgets/config_widget.dart';
import 'utils/waifu_2x_updater.dart';
import 'utils/globals.dart';

void main() async {
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
        primarySwatch: Colors.blue,
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

class _WorkspacePageState extends State<WorkspacePage> {
  void _asyncInit() async {
    if (!await updateWaifuExeExists()) {
      //WaifuExe Doesn't exist, download from repo.
      InstallWaifuExe();
    }
  }

  @override
  void initState() {
    super.initState();
    _asyncInit();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: [
                Flexible(
                  child: ConfigWidget(width: width),
                ),
              ],
            ),
            const Flexible(
              child: PreviewWindow(),
            ),
          ],
        ),
      ),
    );
  }
}
