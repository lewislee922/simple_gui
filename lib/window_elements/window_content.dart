import 'package:flutter/material.dart';

class WindowContent extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints windowConstraints)
      builder;

  const WindowContent({super.key, required this.builder});

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: builder);
}
