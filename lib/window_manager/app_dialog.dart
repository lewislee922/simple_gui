import 'dart:math';

import 'package:flutter/material.dart';

import '../animated_widgets/scale_up.dart';
import '../window_elements/window_status_bar.dart';
import 'app_window.dart';

class AppDialog extends AppWindow {
  AppDialog(
      {super.key,
      super.size = const Size(200, 350),
      required super.globalOffset,
      required super.content,
      super.identifierId = "sys.dialog",
      super.minPointY = 28,
      super.onClose,
      super.stateBarTitle = "",
      super.stateBarHeight = 30,
      super.stateBarBackground = Colors.blue,
      super.margin = 5,
      super.isEnabled = true,
      super.onTapWindow});

  @override
  AppWindowState createState() => _AppDialogState();
}

class _AppDialogState extends AppWindowState {
  MouseCursor _mouseCursorType = SystemMouseCursors.basic;
  late final Size _windowSize;
  late Offset _windowOffset;
  late Offset _previousWindowOffset;

  @override
  void initState() {
    super.initState();
    _windowSize = Size(widget.size.width + (widget.margin * 2),
        widget.size.height + widget.stateBarHeight + widget.margin * 2);
    _previousWindowOffset = widget.globalOffset;
    _windowOffset = widget.globalOffset;
  }

  @override
  Widget build(BuildContext context) {
    final systemSize = Size(MediaQuery.sizeOf(context).width,
        MediaQuery.sizeOf(context).height - widget.minPointY);
    return Positioned.fromRect(
        rect: _windowOffset & _windowSize,
        child: ScaleUp(
          duration: const Duration(milliseconds: 150),
          child: GestureDetector(
            onTap: () {
              if (!widget.isEnabled) {
                widget.onTapWindow?.call();
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                MouseRegion(
                  cursor: _mouseCursorType,
                  onHover: (event) {
                    final offsetdX =
                        (_windowSize.width - event.localPosition.dx).abs();
                    final offsetdY =
                        (_windowSize.height - event.localPosition.dy).abs();

                    setState(() => _mouseCursorType = _getCursorType(offsetdX,
                        offsetdY, Size(_windowSize.width, _windowSize.height)));
                  },
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                color: Colors.black12.withOpacity(0.6),
                                width: 0.6)),
                        color: Colors.grey,
                        shadows: const [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(3, 3),
                              blurRadius: 10)
                        ]),
                    clipBehavior: Clip.hardEdge,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: MouseRegion(
                          cursor: SystemMouseCursors.basic,
                          child: Column(
                            children: [
                              WindowStatusBar(
                                title: widget.stateBarTitle,
                                height: widget.stateBarHeight,
                                backgroundColor: widget.stateBarBackground,
                                isMaximumSize: _windowSize == systemSize,
                                onDragStart: () {
                                  if (!widget.isEnabled) {
                                    widget.onTapWindow?.call();
                                  }
                                },
                                onDragging: (details) {
                                  final newPoint =
                                      _windowOffset + details.delta;
                                  setState(() => _windowOffset = Offset(
                                      newPoint.dx, max(0 - 4, newPoint.dy)));
                                  _previousWindowOffset = _windowOffset;
                                },
                                onClose: () => widget.onClose?.call(),
                              ),
                              Expanded(
                                child: AbsorbPointer(
                                  absorbing: !widget.isEnabled,
                                  child: Navigator(
                                    onPopPage: (route, result) =>
                                        route.didPop(result),
                                    pages: [
                                      MaterialPage(
                                        child: widget.content,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  MouseCursor _getCursorType(double dx, double dy, Size windowSize) {
    if (dx <= 10) {
      if (dy <= 10) {
        return SystemMouseCursors.resizeDownRight;
      }
      if (dy <= windowSize.height - 10 && dy > 10) {
        return SystemMouseCursors.resizeRight;
      }
    } else if (dx <= windowSize.width - 10 && dx > 10) {
      if (dy <= 10) {
        return SystemMouseCursors.resizeDown;
      }
      if (dy <= windowSize.height - 10 && dy > 10) {
        return SystemMouseCursors.resizeUp;
      }
    }

    return SystemMouseCursors.basic;
  }
}
