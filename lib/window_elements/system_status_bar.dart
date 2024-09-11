import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../provider/window_manager_provider.dart';
import 'system_clock.dart';
import 'window_content.dart';

typedef ContextMenuBuilder = Widget Function(
    BuildContext context, Offset offset);

class SystemStatusBar extends ConsumerWidget {
  SystemStatusBar({
    super.key,
    required this.contextMenuBuilder,
    required this.sink,
    this.showContextMenu = false,
  });

  Function(Widget) contextMenuBuilder;
  final StreamSink<ContextMenuMetadata> sink;
  bool showContextMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        sink.add(ContextMenuMetadata()..enabled = false);
      },
      child: SafeArea(
        bottom: false,
        top: true,
        right: false,
        left: false,
        child: Container(
          height: 28,
          width: double.infinity,
          clipBehavior: Clip.hardEdge,
          decoration:
              BoxDecoration(color: Colors.grey.shade400.withOpacity(0.5)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Builder(builder: (context) {
                  return IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(MdiIcons.prescription, size: 24),
                    onPressed: () {
                      final renderbox = context.findRenderObject() as RenderBox;
                      if (renderbox.hasSize && !showContextMenu) {
                        var anchorPoint =
                            Offset(renderbox.paintBounds.left, 28 + 4);
                        final contextMenu = SizedBox(
                          width: 80,
                          child: Builder(builder: (context) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero),
                                      onPressed: () {
                                        ref
                                            .read(windowManagerProvier)
                                            .showDialog(context, _infoDialog);
                                        sink.add(ContextMenuMetadata()
                                          ..enabled = false);
                                      },
                                      child: const Text(
                                        "關於...",
                                        style: TextStyle(height: 1.0),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                        contextMenuBuilder(contextMenu);
                        sink.add(
                            ContextMenuMetadata()..anchorPoint = anchorPoint);
                      } else {
                        sink.add(ContextMenuMetadata()..enabled = false);
                      }
                    },
                  );
                }),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: SystemClock(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  WindowContent get _infoDialog => WindowContent(
        builder: (context, constraints) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade400.withOpacity(0.7),
                      ),
                    ),
                    child: Image.asset("assets/avatars/info.png"),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Simple GUI app"),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("0.0.1"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (await canLaunchUrlString(
                            "https://github.com/lewislee922/simple_gui")) {
                          launchUrlString(
                              "https://github.com/lewislee922/simple_gui");
                        }
                      },
                      icon: const Icon(Ionicons.logo_github),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
}

class ContextMenuMetadata {
  bool enabled = true;
  Offset? anchorPoint;
}
