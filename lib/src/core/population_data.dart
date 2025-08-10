import 'package:genetic_algorithm/src/core/chromosome.dart';
import 'package:genetic_algorithm/src/core/population.dart';

/// A [PopulationData] is the summery of the current generation.
class PopulationData<T> {
  final Population<T> population;
  final int currentGeneration;
  final Duration currentDuration;

  PopulationData({
    required this.population,
    required this.currentGeneration,
    required this.currentDuration,
  });

  Chromosome<T> get fittestChromosome => population.fittestChromosome;
  double get fittestChromosomeFitness => fittestChromosome.fitness;
  double get averagePopulationFitness => population.fitness;
  int get populationSize => population.length;
}
