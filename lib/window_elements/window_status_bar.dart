import 'package:flutter/material.dart';

class WindowStatusBar extends StatelessWidget {
  final VoidCallback? onClose;
  final VoidCallback? onScale;
  final VoidCallback? onMinimize;
  final VoidCallback? onDragStart;
  final Function(DragUpdateDetails details)? onDragging;
  final bool isMaximumSize;
  final double height;
  final Color? backgroundColor;
  final double iconSize;
  final String title;

  const WindowStatusBar(
      {super.key,
      this.onClose,
      this.onScale,
      this.onDragging,
      this.onDragStart,
      this.onMinimize,
      this.isMaximumSize = false,
      this.height = 30,
      this.iconSize = 20,
      this.title = "new window",
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) => onDragging?.call(details),
      onPanStart: (details) => onDragStart?.call(),
      child: Container(
        width: double.infinity,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
            gradient: LinearGradient(colors: [
              backgroundColor ?? Theme.of(context).primaryColor,
              Theme.of(context).scaffoldBackgroundColor
            ], stops: const [
              0.0,
              8
            ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
        child: Row(
          children: [
            Tooltip(
                message: "Close",
                child: GestureDetector(
                    onTap: () => onClose?.call(),
                    child: Icon(Icons.close, size: iconSize))),
            if (onScale != null)
              Tooltip(
                message: isMaximumSize ? "Close fullscreen" : "Fullscreen",
                child: GestureDetector(
                  onTap: () => onScale?.call(),
                  child: Icon(
                      isMaximumSize ? Icons.close_fullscreen : Icons.fullscreen,
                      size: iconSize),
                ),
              ),
            if (onMinimize != null)
              Tooltip(
                message: "Minimize",
                child: GestureDetector(
                    onTap: () => onMinimize?.call(),
                    child: Icon(Icons.minimize, size: iconSize)),
              ),
            const SizedBox(width: 10),
            if (title != "")
              FittedBox(
                  child: Text(title, style: TextStyle(fontSize: iconSize))),
          ],
        ),
      ),
    );
  }
}
