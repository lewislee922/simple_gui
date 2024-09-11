import 'package:flutter/material.dart';

// Desktop data & widget
enum IconType { file, shortcut }
// enum IconType { file, folder, shortcut }

abstract class DesktopIcon extends StatelessWidget {
  final String name;
  final Widget icon;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;

  const DesktopIcon({
    super.key,
    required this.icon,
    this.selected = false,
    this.onDoubleTap,
    this.onTap,
    required this.name,
  });

  @override
  Widget build(BuildContext context);
}

abstract class ShortcutIcon extends DesktopIcon {
  const ShortcutIcon(
      {super.key,
      super.onDoubleTap,
      super.onTap,
      super.selected,
      required super.icon,
      required super.name});

  @override
  Widget build(BuildContext context);
}
