import 'package:genetic_algorithm/src/core/population_data.dart';
import 'package:genetic_algorithm/src/termination/termination_condition.dart';

/// A [UserCancelTermination] is condtion for graphic program to terminate the evolution engine
/// when the user trigger action (like press button).
class UserCancelTermination<T> implements TerminationCondition<T> {
  bool _cancel = false;

  @override
  bool shouldTerminate(PopulationData<T> data) => isCancel;

  bool get isCancel => _cancel;
  void cancel() => _cancel = true;
  void reset() => _cancel = false;
}
