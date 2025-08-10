import 'dart:math';

import 'package:genetic_algorithm/src/core/chromosome.dart';
import 'package:genetic_algorithm/src/core/population.dart';
import 'package:genetic_algorithm/src/selection/selection_strategy.dart';

class TournamentSelection<T> implements SelectionStrategy<T> {
  final int selectionSize;
  final double probability;

  TournamentSelection({
    required this.selectionSize,
    required this.probability,
  });

  @override
  Chromosome<T> select(Population<T> population, Random rnd) {
    final chromosomes = <Chromosome<T>>[];

    for (int i = 0; i < selectionSize; i++) {
      final chromosome1 = population.elementAt(rnd.nextInt(population.length));
      final chromosome2 = population.elementAt(rnd.nextInt(population.length));

      if (rnd.nextDouble() >= probability) {
        chromosomes.add(chromosome1.fitness > chromosome2.fitness
            ? chromosome1
            : chromosome2);
      } else {
        chromosomes.add(chromosome1.fitness > chromosome2.fitness
            ? chromosome2
            : chromosome1);
      }
    }
    chromosomes.sort();
    return chromosomes.first;
  }
}
