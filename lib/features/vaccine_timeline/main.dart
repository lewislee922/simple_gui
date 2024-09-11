import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/timeline.dart';
import 'models/vaccine.dart';
import 'pages/home_page.dart';
import 'services/local_data_service.dart';
import 'services/local_data_service_impl.dart';
import 'themes/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final json = await rootBundle.loadString("assets/vaccines.json");
  runApp(MainApp(
    service: LocalDataServiceImpl(jsonDecode(json)),
  ));
}

class MainApp extends StatelessWidget {
  final LocalDataService<Vaccine, VaccineTimeline> service;
  const MainApp({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context).copyWith(
          brightness: Brightness.light,
          colorScheme: const ColorScheme.light(
              primary: AppColors.primary, surface: AppColors.background)),
      home: VaccineHomePage(service: service),
    );
  }
}
