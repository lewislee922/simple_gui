class VaccineTimeline {
  final String name;
  final String verison;
  final String intervalLink;
  final List<RecommandVaccines> recommands;

  VaccineTimeline.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        verison = json['version'],
        intervalLink = json['intervalrecommandlink'],
        recommands = List<Map<String, dynamic>>.from(json['data'])
            .map((item) => RecommandVaccines.fromJson(item))
            .toList();
}

class RecommandVaccines {
  final String? timeAlias;
  final Duration recomStartTime;
  final List<int> acceptable;
  final List<int> doseNo;
  final List<String?>? othernote;

  RecommandVaccines.fromJson(Map<String, dynamic> json)
      : timeAlias = json['timealias'],
        recomStartTime = Duration(days: json['recomstarttime']),
        acceptable = List<int>.from(json['acceptable']),
        doseNo = List<int>.from(json['doseno']),
        othernote =
            json['othernote'] != null ? List.from(json['othernote']) : null;
}
