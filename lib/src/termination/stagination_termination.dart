import 'package:genetic_algorithm/src/core/population_data.dart';
import 'package:genetic_algorithm/src/termination/termination_condition.dart';

/// [StaginationTermination] is condition to terminate the evolution engine if there is no
/// enchace notice in the population fitness after reach number of generatons [generationLimit].
class StaginationTermination<T> implements TerminationCondition<T> {
  final int generationLimit;
  double _bestFitness = 0;
  int _bestFitnessGeneration = 0;

  StaginationTermination(this.generationLimit);

  @override
  bool shouldTerminate(PopulationData<T> data) {
    if (data.fittestChromosome.fitness > _bestFitness) {
      _bestFitness = data.fittestChromosome.fitness;
      _bestFitnessGeneration = data.currentGeneration;
    }

    return data.currentGeneration - _bestFitnessGeneration > generationLimit;
  }
}
