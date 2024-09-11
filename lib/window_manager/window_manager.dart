import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../gui_app.dart';
import '../desktop_icons/drugs_icon.dart';
import '../desktop_icons/liverpool_icon.dart';
import '../desktop_icons/uptodate_icon.dart';
import '../window_elements/window_content.dart';
import 'app_dialog.dart';
import 'app_window.dart';

class WindowManager extends StatefulWidget {
  static final WindowManager _manager = WindowManager._();

  static WindowManager get shared => _manager;

  void Function(GUIApp app) get runApp => _state.runApp;

  void Function(BuildContext context, WindowContent content) get showDialog =>
      _state.showDialog;

  WindowManager._();

  final WindowManagerState _state = WindowManagerState();

  final List<AppWindow> _windows = [];

  @override
  WindowManagerState createState() => _state;
}

class WindowManagerState extends State<WindowManager> {
  int? selectedIndex;

  runApp(GUIApp app) {
    if (widget._windows.isNotEmpty) {
      widget._windows.last.isEnabled = false;
    }

    if (!app.appSetting.multiInstance) {
      final sameInstanceIndex = widget._windows.lastIndexWhere(
          (element) => element.identifierId == app.appSetting.identifierId);
      if (sameInstanceIndex != -1) {
        moveToFront(
            (widget._windows[sameInstanceIndex].key! as ValueKey<String>)
                .value);
        return;
      }
    }

    widget._windows.add(_createWindow(app));
    setState(() => widget._windows);
  }

  showDialog(BuildContext context, WindowContent content) {
    final size = MediaQuery.sizeOf(context);
    final anchorPoint =
        Offset((size.width - 200) / 2, ((size.height - 350 - 28) / 2) * 0.6);
    final windowId = const Uuid().v4();
    final dialog = AppDialog(
      key: ValueKey(windowId),
      globalOffset: anchorPoint,
      content: content,
      onClose: () => removeWindow(windowId),
      onTapWindow: () => moveToFront(windowId),
    );
    if (widget._windows.isNotEmpty) {
      widget._windows.last.isEnabled = false;
    }
    widget._windows.add(dialog);

    setState(() => widget._windows);
  }

  removeWindow(String windowId) {
    try {
      final AppWindow result = widget._windows
          .firstWhere((element) => (element.key as ValueKey).value == windowId);
      widget._windows.remove(result);
      if (widget._windows.isNotEmpty) {
        widget._windows.last.isEnabled = true;
      }
      setState(() => widget._windows);
    } on StateError {
      // do nothing??;
    }
  }

  moveToFront(String windowId) {
    try {
      final AppWindow result = widget._windows.firstWhere(
          (element) => (element.key as ValueKey<String>).value == windowId);
      if (widget._windows.isNotEmpty) {
        widget._windows.last.isEnabled = false;
      }
      widget._windows.remove(result);
      result.isEnabled = true;
      widget._windows.add(result);
      setState(() => widget._windows);
    } on StateError {
      // do nothing??;
    }
  }

  AppWindow _createWindow(GUIApp app) {
    final windowId = const Uuid().v4();
    final maxOffset = widget._windows.fold<Offset>(
        Offset.zero,
        (previousValue, element) => previousValue > element.globalOffset
            ? previousValue
            : element.globalOffset);
    return AppWindow(
        onClose: () => removeWindow(windowId),
        onTapWindow: () => moveToFront(windowId),
        key: ValueKey<String>(windowId),
        identifierId: app.appSetting.identifierId,
        stateBarTitle: app.appSetting.name,
        size: app.windowSetting.minWindowSize,
        globalOffset: widget._windows
                .where((element) =>
                    element.globalOffset == app.windowSetting.initialPoint)
                .isNotEmpty
            ? maxOffset + const Offset(10, 10)
            : app.windowSetting.initialPoint,
        content: app.content);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          GestureDetector(
              onTap: () {
                if (selectedIndex != null) {
                  setState(() => selectedIndex = null);
                }
              },
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              )),
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(children: [
                  UptodateShortcutIcon(
                    onTap: () => setState(() => selectedIndex = 0),
                    onDoubleTap: Platform.isIOS
                        ? () => runApp(WebSiteApp(
                              title: "UpToDate",
                              urlString:
                                  "https://www.uptodate.com/contents/search",
                              identifierId: "org.lewislee.webapp.uptodate",
                            ))
                        : null,
                    isSelected: (selectedIndex ?? -1) == 0,
                  ),
                  DrugsIcon(
                    onTap: () => setState(() => selectedIndex = 1),
                    onDoubleTap: Platform.isIOS
                        ? () => runApp(WebSiteApp(
                            title: "Drugs",
                            urlString: "https://www.drugs.com",
                            identifierId: "org.lewislee.webapp.drugs",
                            multiInstance: true))
                        : null,
                    isSelected: (selectedIndex ?? -1) == 1,
                  ),
                  LiverpoolIcon(
                    onTap: () => setState(() => selectedIndex = 2),
                    onDoubleTap: Platform.isIOS
                        ? () => runApp(WebSiteApp(
                              title: "Liverpool",
                              urlString:
                                  "https://www.hiv-druginteractions.org/checker#",
                              identifierId: "org.lewislee.webapp.liverpool",
                            ))
                        : null,
                    isSelected: (selectedIndex ?? -1) == 2,
                  )
                ]),
              )),
          ...widget._windows,
        ],
      ),
    );
  }
}
