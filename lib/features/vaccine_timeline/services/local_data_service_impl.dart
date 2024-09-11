import '../models/timeline.dart';
import '../models/vaccine.dart';
import 'local_data_service.dart';

class LocalDataServiceImpl
    implements LocalDataService<Vaccine, VaccineTimeline> {
  final Map<String, dynamic> data;

  LocalDataServiceImpl(this.data);

  @override
  VaccineTimeline getTimeline() {
    return VaccineTimeline.fromJson(data);
  }

  @override
  List<Vaccine> getVaccineInfo() {
    return List.from(data['vaccines']).map((e) => Vaccine.fromJson(e)).toList();
  }
}
