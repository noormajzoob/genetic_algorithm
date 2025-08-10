import 'package:genetic_algorithm/src/core/population_data.dart';
import 'package:genetic_algorithm/src/termination/termination_condition.dart';

/// A [ElapsedTimeTermination] is condtion that terminate the evolution engine after
/// period of time [maxDuration].
class ElapsedTimeTermination<T> implements TerminationCondition<T> {
  final Duration maxDuration;

  ElapsedTimeTermination(this.maxDuration);

  @override
  bool shouldTerminate(PopulationData<T> data) =>
      data.currentDuration >= maxDuration;
}
