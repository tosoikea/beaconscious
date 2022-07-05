import 'package:beaconscious/repositories/environments/models/models.dart';

abstract class EnvironmentsRepository {
  Future<bool> addEnvironment({required Environment environment});
  Future<bool> updateEnvironment(
      {required String environmentId, required Environment environment});
  Future<bool> removeEnvironment({required String environmentId});

  /// Returns a stream that updates with all environments currently known to the application.
  Stream<List<Environment>> streamEnvironments();
}
