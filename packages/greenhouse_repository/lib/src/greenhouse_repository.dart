import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenhouse_repository/greenhouse_repository.dart';
import 'package:meta/meta.dart';

class GreenhouseRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Particle>> getParticles() async {
    try {
      final result = await firestore.collection('particles').get();
      return result.docs.map<Particle>((d) => Particle(
        id: d.data()['particle_id'] as String,
        name: d.data()['particle_name'] as String,
        description: d.data()['particle_description'] as String,
        sensors: (d.data()['sensors'])?.map<Sensor>((e) => Sensor(name: e.toString()))?.toList() ?? <Sensor>[]
      )).toList();
    } catch(e) {
      print(e);
      return null;
    }
  }

  /// Returns the measured values of a sensor of a particle in the last day.
  Future<List<Measurement>> getRecentMeasurement({@required Particle particle, @required Sensor sensor, @required DateTime date}) async {
    try {
      final snapshot = await firestore.collection('data')
        .where('particle_id', isEqualTo: particle.id)
        .where('sensor', isEqualTo: sensor.name)
        .where('min_timestamp', isGreaterThan: Timestamp.fromDate(date.subtract(Duration(days: 1))))
        .where('min_timestamp', isLessThan: Timestamp.fromDate(date))
        .get();

      final List<Measurement> result = [];
      for (final doc in snapshot.docs) {
        for (final value  in doc.data()['values']) {
          result.add(Measurement(
            timestamp: (value['timestamp'] as Timestamp).toDate(),
            value: value['value'] as double,
          ));
        }
      }

      return result;
    } catch(e) {
      print(e);
      return null;
    }
  }
}
