import 'dart:math';

import 'package:genetic_algorithm/src/core/population.dart';
import 'package:genetic_algorithm/src/engine/evolution_engine.dart';

/// A [GenerationEvolutionEngine] is an engine that create next population
/// by appling the [evolutionScheme] to the current population.
class GenerationEvolutionEngine<T> extends EvolutionEngine<T> {
  GenerationEvolutionEngine({
    required super.populationFactory,
    required super.fitnessEvaluator,
    required super.evolutionScheme,
  });

  @override
  Future<Population<T>> nextPopulation(
      Population<T> population, int eliteCount, Random rnd) async {
    final eliteChromosomes = population.subChromosomes(0, eliteCount);

    final chromosomes = population.skip(eliteCount).toList();
    final operatedPopulation =
        evolutionScheme.apply(Population(chromosomes), rnd);

    return Population.merge([eliteChromosomes, operatedPopulation]);
  }
}
