class Vaccine {
  final int id;
  final bool isActive;
  final String engName;
  final String chiName;
  final String? timelineNote;
  final String detailLink;

  Vaccine.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        isActive = json['isactive'],
        engName = json['engname'],
        chiName = json['chiname'],
        timelineNote = json['timelinenote'],
        detailLink = json['detaillink'];
}

// class IntervalRecommandChart {
//   final String version;
//   final List<>
// }

// class IntervalRecommand {
//   final String type;
//   final List<String> recommands;

// }