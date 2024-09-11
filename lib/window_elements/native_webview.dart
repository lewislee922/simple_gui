import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppleWebView extends StatefulWidget {
  final String startUrlString;

  const AppleWebView({super.key, required this.startUrlString});

  @override
  State<StatefulWidget> createState() => NatvieWebviewState();
}

class NatvieWebviewState extends State<AppleWebView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    return UiKitView(
      viewType: "@views/native-webview",
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
          () => TapGestureRecognizer(),
        ),
      },
      creationParamsCodec: const StandardMessageCodec(),
      creationParams: Map<String, dynamic>.from({
        "width": renderBox?.constraints.maxWidth ?? 100.0,
        "height": renderBox?.constraints.maxHeight ?? 100.0,
        "initUrlString": widget.startUrlString
      }),
    );
  }
}
