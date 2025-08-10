import 'dart:math';

import 'package:genetic_algorithm/src/core/chromosome.dart';
import 'package:genetic_algorithm/src/core/population.dart';
import 'package:genetic_algorithm/src/selection/selection_strategy.dart';

class RouletteWheelSelection<T> implements SelectionStrategy<T> {
  @override
  Chromosome<T> select(Population<T> population, Random rnd) {
    double populationFitness = population.fitness;
    double rouletteWheelPosition = rnd.nextDouble() * populationFitness;

    double spinWheel = 0;
    for (Chromosome<T> chromosome in population) {
      spinWheel += chromosome.fitness;
      if (spinWheel >= rouletteWheelPosition) {
        return chromosome;
      }
    }

    return population.last;
  }
}
