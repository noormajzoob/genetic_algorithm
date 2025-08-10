import 'package:genetic_algorithm/src/core/population_data.dart';
import 'package:genetic_algorithm/src/termination/termination_condition.dart';

/// A [GenerationCountTermination] is condtion that terminate the evolution engine after
/// number of generations [count].
class GenerationCountTermination<T> implements TerminationCondition<T> {
  final int count;

  GenerationCountTermination(this.count);

  @override
  bool shouldTerminate(PopulationData<T> data) =>
      data.currentGeneration == count;
}
