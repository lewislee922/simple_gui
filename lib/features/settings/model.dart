// System Setting Model, store in shared preference

import 'package:flutter/material.dart';

class SystemSetting {
  // brightness
  final Brightness brightness;
  // desktop image path
  final String desktopImagePath;
  // auto hide dock
  final bool autoHideDock;

  // constructor
  SystemSetting({
    required this.brightness,
    required this.desktopImagePath,
    required this.autoHideDock,
  });

  // from json map
  SystemSetting.fromJson(Map<String, dynamic> json)
      : brightness = _intToBrightness(json['brightness']),
        desktopImagePath = json['desktopImagePath'],
        autoHideDock = json['autoHideDock'];

  // to json map
  Map<String, dynamic> toJson() => {
        'brightness': _brightnessToInt(),
        'desktopImagePath': desktopImagePath,
        'autoHideDock': autoHideDock,
      };

  // brightness to int
  int _brightnessToInt() {
    if (brightness == Brightness.dark) {
      return 1;
    } else {
      return 0;
    }
  }

  // int to brightness
  static Brightness _intToBrightness(int value) {
    if (value == 1) {
      return Brightness.dark;
    } else {
      return Brightness.light;
    }
  }

  // copy with
  SystemSetting copyWith({
    Brightness? brightness,
    String? desktopImagePath,
    bool? autoHideDock,
  }) {
    return SystemSetting(
      brightness: brightness ?? this.brightness,
      desktopImagePath: desktopImagePath ?? this.desktopImagePath,
      autoHideDock: autoHideDock ?? this.autoHideDock,
    );
  }
}

// class SystemSetting {
//   final Color statusBarColor;
//   final DateTimeSetting timeSetting;
// }

// class DateTimeSetting {
//   final String format;

//   DateTimeSetting(this.format);
// }

// path: /settings/_ value: string
