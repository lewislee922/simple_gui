import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'gui_app.dart';
import 'window_elements/system_status_bar.dart';
import '/features/vaccine_timeline/services/local_data_service_impl.dart';
import '/provider/window_manager_provider.dart';
import '/window_manager/app_dock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final json =
      await rootBundle.loadString("assets/vaccine_timeline/vaccines.json");

  runApp(
    // prepare for global environment
    ProviderScope(
      child: MainApp(
        apps: [
          VaccineTimelineApp(LocalDataServiceImpl(jsonDecode(json))),
        ],
      ),
    ),
  );
}

class MainApp extends ConsumerStatefulWidget {
  final List<GUIApp> apps;

  const MainApp({super.key, this.apps = const []});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends ConsumerState<MainApp> {
  late final StreamController<ContextMenuMetadata>
      globalContextMenuStateController;
  Widget _contextMenu = const SizedBox();

  @override
  void initState() {
    super.initState();
    globalContextMenuStateController =
        StreamController<ContextMenuMetadata>.broadcast();
  }

  @override
  void dispose() {
    globalContextMenuStateController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final windowManager = ref.read(windowManagerProvier);
    final stream = globalContextMenuStateController.stream.asBroadcastStream();
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      top: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Iansui'),
        title: "SimpleGUI",
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => globalContextMenuStateController.sink
                    .add(ContextMenuMetadata()..enabled = false),
                child: SizedBox.expand(
                  child: Image.asset(
                    'assets/window_system/default_desktop.jpeg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    StreamBuilder<ContextMenuMetadata>(
                        stream: stream,
                        builder: (context, snapshot) {
                          final enabled = snapshot.data?.enabled ?? false;
                          return SystemStatusBar(
                              showContextMenu: enabled,
                              sink: globalContextMenuStateController.sink,
                              contextMenuBuilder: (contextMenu) =>
                                  _contextMenu = contextMenu);
                        }),
                    Expanded(
                      child: SafeArea(
                        bottom: false,
                        left: false,
                        right: false,
                        top: false,
                        child: windowManager,
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<ContextMenuMetadata>(
                  stream: stream,
                  builder: (context, snapshot) {
                    if (snapshot.data?.enabled ?? false) {
                      return Transform.translate(
                          offset: snapshot.data!.anchorPoint!,
                          child: _contextMenu);
                    }
                    return const SizedBox();
                  })
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: AppDock(
              apps: widget.apps,
              onStartApp: (app) => windowManager.runApp(app)),
        ),
      ),
    );
  }
}
