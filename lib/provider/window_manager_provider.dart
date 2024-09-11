import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/window_manager/window_manager.dart';

final Provider<WindowManager> windowManagerProvier =
    Provider<WindowManager>((ref) => WindowManager.shared);
