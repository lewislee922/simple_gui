import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/timeline.dart';
import '../models/vaccine.dart';
import '../services/local_data_service.dart';
import '../themes/app_colors.dart';

class VaccineHomePage extends StatefulWidget {
  const VaccineHomePage({
    super.key,
    required this.service,
  });

  final LocalDataService<Vaccine, VaccineTimeline> service;

  @override
  State<VaccineHomePage> createState() => _VaccineHomePageState();
}

class _VaccineHomePageState extends State<VaccineHomePage> {
  late List<Vaccine> vaccine;
  late VaccineTimeline timeline;
  int _currentDays = 1;

  final _chinNo = ["一劑", "第一劑", "第二劑", "第三劑", "第四劑"];

  @override
  void initState() {
    super.initState();
    vaccine = widget.service.getVaccineInfo();
    timeline = widget.service.getTimeline();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(
          brightness: Brightness.light,
          colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary, surface: AppColors.background)),
      home: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            timeline.name,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Image.asset(
                            'assets/vaccine_timeline/images/infant.png'),
                      ),
                      Flexible(
                        flex: 4,
                        child: Slider(
                          value: _currentDays.toDouble(),
                          divisions: timeline.recommands.length - 1,
                          min: 0,
                          max: timeline.recommands.length.toDouble() - 1,
                          label: timeline.recommands
                              .map((e) => e.timeAlias)
                              .toList()[_currentDays.round()]
                              .toString(),
                          onChanged: (value) => setState(() {
                            _currentDays = value.round();
                          }),
                        ),
                      ),
                      Flexible(
                        child: Image.asset(
                            'assets/vaccine_timeline/images/children.png'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: AppColors.primary),
                        child: Text(
                          timeline.recommands
                              .map((e) => e.timeAlias)
                              .toList()[_currentDays.round()]
                              .toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      FilledButton(
                          onPressed: () async {
                            if (await canLaunchUrlString(
                                timeline.intervalLink)) {
                              launchUrlString(timeline.intervalLink);
                            }
                          },
                          child: const Text("接種間隔建議")),
                    ],
                  ),
                ),
                ..._getVaccineNote()
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getVaccineNote() {
    final result = <Widget>[];

    final vaccines = vaccine.where((element) =>
        timeline.recommands[_currentDays].acceptable.contains(element.id));
    List<String?>? totalNote;
    if (timeline.recommands[_currentDays].othernote != null) {
      totalNote = timeline.recommands[_currentDays].othernote;
    }
    for (final vaccine in vaccines) {
      final noDose = timeline.recommands[_currentDays].doseNo[
          timeline.recommands[_currentDays].acceptable.indexOf(vaccine.id)];
      String? note;
      if (totalNote != null) {
        note = totalNote[
            timeline.recommands[_currentDays].acceptable.indexOf(vaccine.id)];
      }
      final card = GestureDetector(
        onTap: () async {
          if (await canLaunchUrlString(vaccine.detailLink)) {
            launchUrlString(vaccine.detailLink);
          }
        },
        child: Card(
          color: AppColors.secondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(vaccine.chiName,
                              style: const TextStyle(
                                  color: AppColors.background,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.action),
                              child: Text(_chinNo[noDose],
                                  style: const TextStyle(
                                      color: AppColors.background,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8.0),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.alert),
                              child: Text(
                                  "${vaccine.isActive ? "活化" : "不活化"}疫苗",
                                  style: const TextStyle(
                                      color: AppColors.background,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (vaccine.timelineNote != null || note != null)
                    const Divider(color: AppColors.background),
                  if (vaccine.timelineNote != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        vaccine.timelineNote ?? "",
                        style: const TextStyle(
                            color: AppColors.background, fontSize: 14),
                        maxLines: 10,
                      ),
                    ),
                  if (note != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "註：$note",
                        style: const TextStyle(
                            color: AppColors.background, fontSize: 14),
                        maxLines: 10,
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      );
      result.add(card);
    }
    return result;
  }
}
