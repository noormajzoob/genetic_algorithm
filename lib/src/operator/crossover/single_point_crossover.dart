import 'dart:math';

import 'package:genetic_algorithm/src/operator/crossover/crossover.dart';

/// [SinglePointCrossover] is an operator that split the parents using swap point
/// and the new chromosome will have the genes before swap point from parent1 and
/// genes after swap point form parent2.
class SinglePointCrossover<T> extends Crossover<Iterable<T>> {
  SinglePointCrossover({
    required super.probability,
    required super.selectionStrategy,
  });

  @override
  Iterable<T> crossover(Iterable<T> parent1, Iterable<T> parent2, Random rnd) {
    final offspring = <T>[];

    int swapPoint = rnd.nextInt(parent1.length);
    print(swapPoint);

    for (int i = 0; i < parent1.length; i++) {
      if (i < swapPoint) {
        offspring.add(parent1.elementAt(i));
      } else {
        offspring.add(parent2.elementAt(i));
      }
    }

    return offspring;
  }
}
