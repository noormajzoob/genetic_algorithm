import 'dart:math';

import 'package:genetic_algorithm/src/core/population.dart';
import 'package:genetic_algorithm/src/engine/evolution_engine.dart';
import 'package:genetic_algorithm/src/util/error.dart';

/// A [PlusSelectionStrategyEngine] is an engine that create next population
/// by select randommly chromosomes from population with size
/// equal to (population size * [offspringMultiplier]), then evaluted these
/// chromosomes and apply the [evolutionScheme] to them, in the last added the current
/// population chromosomes to them, sort them and select the sub chromosomes from them
/// in range (0, population size).
class PlusSelectionStrategyEngine<T> extends EvolutionEngine<T> {
  final int offspringMultiplier;

  PlusSelectionStrategyEngine({
    required super.populationFactory,
    required super.fitnessEvaluator,
    required super.evolutionScheme,
    this.offspringMultiplier = 3,
  });

  @override
  Future<Population<T>> nextPopulation(
      Population<T> population, int eliteCount, Random rnd) async {
    if (eliteCount > 0) {
      throw GeneticError(
          'Explicit elitism is not supported for "PlusSelectionStrategyEngine", eliteCount should be 0.');
    }

    final offspringCount = offspringMultiplier * population.length;
    final parentChromosomes = List.generate(offspringCount, (index) {
      final index = rnd.nextInt(population.length);

      return population.elementAt(index);
    });
    final parents = Population(parentChromosomes);
    final offspring = evolutionScheme.apply(parents, rnd);
    final evaluatedOffspring = (await evaluatePopulation(offspring))
      ..append(population)
      ..sort();

    return evaluatedOffspring.subPopulation(0, population.length);
  }
}
