import 'package:genetic_algorithm/src/core/population_data.dart';
import 'package:genetic_algorithm/src/termination/termination_condition.dart';

/// A [TargetValueTermination] is condtion that terminate the evolution engine after
/// reach specific fitness [value].
class TargetValueTermination<T> implements TerminationCondition<T> {
  final double value;

  TargetValueTermination(this.value);

  @override
  bool shouldTerminate(PopulationData<T> data) =>
      data.fittestChromosomeFitness >= value;
}
