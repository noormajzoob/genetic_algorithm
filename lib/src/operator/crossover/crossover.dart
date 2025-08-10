import 'dart:math';

import 'package:genetic_algorithm/src/core/chromosome.dart';
import 'package:genetic_algorithm/src/core/population.dart';
import 'package:genetic_algorithm/src/operator/genetic_operator.dart';
import 'package:genetic_algorithm/src/selection/selection_strategy.dart';

export './single_point_crossover.dart';
export './tow_point_crossover.dart';
export './unifor_crossover.dart';
export './order_crossover.dart';
export './string_crossover.dart';

/// A [Crossover] is an operator that share the information (genes) of chromosome
/// based on [probability].
///
/// The [selectionStrategy] is the strategy to selected the chromsomes they will
/// share thier information.
abstract class Crossover<T> implements GeneticOperator<T> {
  final double probability;
  final SelectionStrategy<T> selectionStrategy;

  Crossover({required this.probability, required this.selectionStrategy});

  @override
  Population<T> apply(Population<T> population, Random rnd) {
    final chromosomes = <Chromosome<T>>[];

    for (int i = 0; i < population.length; i++) {
      final parent1 = population.elementAt(i);

      if (probability > rnd.nextDouble()) {
        final parent2 = selectionStrategy.select(population, rnd);
        final offspring = crossover(parent1.data, parent2.data, rnd);

        chromosomes.add(Chromosome.data(offspring));
      } else {
        chromosomes.add(parent1);
      }
    }
    return Population(chromosomes);
  }

  T crossover(T parent1, T parent2, Random rnd);
}
