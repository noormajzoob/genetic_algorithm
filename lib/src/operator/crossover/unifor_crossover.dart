import 'dart:math';

import 'package:genetic_algorithm/src/operator/crossover/crossover.dart';

/// [UniformCrossover] is an operator generate the new chromosome form it parents.
///
/// the new chromosome's genes will have probability 50% to get from each parent.
class UniformCrossover<T> extends Crossover<Iterable<T>> {
  UniformCrossover({
    required super.probability,
    required super.selectionStrategy,
  });

  @override
  Iterable<T> crossover(Iterable<T> parent1, Iterable<T> parent2, Random rnd) {
    final offspring = <T>[];

    for (int i = 0; i < parent1.length; i++) {
      if (rnd.nextDouble() >= 0.5) {
        offspring.add(parent1.elementAt(i));
      } else {
        offspring.add(parent2.elementAt(i));
      }
    }

    return offspring;
  }
}
