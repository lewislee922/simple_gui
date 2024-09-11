import 'dart:ui';

import 'package:flutter/material.dart';

import '../animated_widgets/slide_up.dart';
import '../gui_app.dart';

class AppDock extends StatelessWidget {
  final List<GUIApp> apps;
  final void Function(GUIApp app) onStartApp;

  const AppDock({super.key, required this.apps, required this.onStartApp});

  @override
  Widget build(BuildContext context) {
    return SlideUp(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          color: Colors.white60.withOpacity(0.4),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: apps
                      .map((app) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FloatingActionButton(
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                tooltip: app.appSetting.name,
                                child: app.appSetting.iconUrl == ""
                                    ? const Icon(Icons.app_shortcut)
                                    : Image.asset(app.appSetting.iconUrl),
                                onPressed: () => onStartApp(app)),
                          ))
                      .toList()),
            ),
          ),
        ),
      ),
    );
  }
}
