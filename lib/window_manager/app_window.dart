import 'dart:math';

import 'package:flutter/material.dart';
import '/animated_widgets/scale_up.dart';
import '/window_elements/window_content.dart';
import '/window_elements/window_status_bar.dart';

class AppWindow extends StatefulWidget {
  // actions
  // drag avoid top status bar
  // remove on tap minimize
  // tell child window is resized
  bool isEnabled;

  final String identifierId;

  final VoidCallback? onTapWindow;
  final VoidCallback? onClose;
  final double minPointY;

  final Size size;
  final Offset globalOffset;
  final double margin;

  final String stateBarTitle;
  final double stateBarHeight;
  final Color stateBarBackground;

  final WindowContent content;
  //final Widget Function(BuildContext, BoxConstraints) builder;
  Rect get rect => (globalOffset & size);

  AppWindow(
      {required this.size,
      required this.globalOffset,
      required this.content,
      required this.identifierId,
      this.minPointY = 28,
      //required this.builder,
      super.key,
      this.onClose,
      this.stateBarTitle = "",
      this.stateBarHeight = 30,
      this.stateBarBackground = Colors.blue,
      this.margin = 5,
      this.isEnabled = true,
      this.onTapWindow});

  @override
  AppWindowState createState() => AppWindowState();
}

class AppWindowState extends State<AppWindow>
    with SingleTickerProviderStateMixin {
  MouseCursor _mouseCursorType = SystemMouseCursors.basic;
  late Size _windowSize;
  late Offset _windowOffset;
  late Size _previousWindowSize;
  late Offset _previousWindowOffset;

  @override
  void initState() {
    super.initState();
    _windowSize = Size(widget.size.width + (widget.margin * 2),
        widget.size.height + widget.stateBarHeight + widget.margin * 2);
    _previousWindowSize = _windowSize;
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
                GestureDetector(
                  onPanUpdate: (details) {
                    Size newSize;
                    switch (_mouseCursorType) {
                      case SystemMouseCursors.resizeDownRight:
                        newSize = _windowSize + details.delta;
                      case SystemMouseCursors.resizeRight:
                        newSize = _windowSize + Offset(details.delta.dx, 0);
                      case SystemMouseCursors.resizeDown:
                        newSize = _windowSize + Offset(0, details.delta.dy);
                      default:
                        newSize = Size.zero;
                    }
                    if (newSize != Size.zero) {
                      setState(
                        () => _windowSize = Size(
                          max(widget.size.width + 10,
                              min(newSize.width, systemSize.width)),
                          max(widget.size.height + 32,
                              min(newSize.height, systemSize.height)),
                        ),
                      );
                    }
                    _previousWindowSize = _windowSize;
                  },
                  child: MouseRegion(
                    cursor: _mouseCursorType,
                    onHover: (event) {
                      final offsetdX =
                          (_windowSize.width - event.localPosition.dx).abs();
                      final offsetdY =
                          (_windowSize.height - event.localPosition.dy).abs();

                      setState(() => _mouseCursorType = _getCursorType(
                          offsetdX,
                          offsetdY,
                          Size(_windowSize.width, _windowSize.height)));
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
                                  onScale: () {
                                    if (!widget.isEnabled) {
                                      widget.onTapWindow?.call();
                                    }
                                    setState(
                                      () {
                                        if (_windowSize != systemSize) {
                                          _windowOffset =
                                              const Offset(0, 0 - 4);
                                          _windowSize = systemSize;
                                        } else {
                                          _windowOffset = _previousWindowOffset;
                                          _windowSize = _previousWindowSize;
                                        }
                                      },
                                    );
                                  }),
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
