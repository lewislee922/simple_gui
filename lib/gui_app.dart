import 'package:flutter/material.dart';

import 'features/vaccine_timeline/models/timeline.dart';
import 'features/vaccine_timeline/models/vaccine.dart';
import 'features/vaccine_timeline/pages/home_page.dart';
import 'features/vaccine_timeline/services/local_data_service.dart';
import '/window_elements/native_webview.dart';
import '/window_elements/window_content.dart';

// app interface
abstract interface class GUIApp {
  final AppSetting appSetting;
  final WindowSetting windowSetting;
  final WindowContent content;

  GUIApp(
      {required this.appSetting,
      required this.windowSetting,
      required this.content});
}

class AppSetting {
  final String name;
  final String iconUrl;
  final bool multiInstance;
  final String identifierId;

  AppSetting(this.name, this.iconUrl, this.identifierId, {bool? multiInstance})
      : multiInstance = multiInstance ?? false;
}

class WindowSetting {
  final Size minWindowSize;
  final Offset initialPoint;

  WindowSetting(this.minWindowSize, this.initialPoint);
}

// app instances
class VaccineTimelineApp implements GUIApp {
  final LocalDataService<Vaccine, VaccineTimeline> _service;

  VaccineTimelineApp(this._service);

  @override
  AppSetting get appSetting => AppSetting("疫苗接種時程",
      "assets/vaccine_timeline/appIcon.png", "org.lewislee.vaccine_timeline");

  @override
  WindowSetting get windowSetting =>
      WindowSetting(const Size(382, 667), const Offset(20, 20));

  @override
  WindowContent get content => WindowContent(
        builder: (_, constraints) => ConstrainedBox(
          constraints: constraints,
          child: VaccineHomePage(service: _service),
        ),
      );
}

class WebSiteApp implements GUIApp {
  final String title;
  final String identifierId;
  final String urlString;
  final bool multiInstance;

  WebSiteApp(
      {required this.title,
      required this.urlString,
      required this.identifierId,
      this.multiInstance = false});

  @override
  AppSetting get appSetting =>
      AppSetting(title, "", identifierId, multiInstance: multiInstance);

  @override
  WindowSetting get windowSetting =>
      WindowSetting(const Size(382, 667), const Offset(20, 20));

  @override
  WindowContent get content => WindowContent(
        builder: (_, constraints) => ConstrainedBox(
          constraints: constraints,
          child: AppleWebView(startUrlString: urlString),
        ),
      );
}
