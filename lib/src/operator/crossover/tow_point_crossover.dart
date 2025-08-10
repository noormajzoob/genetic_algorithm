import 'dart:math';

import 'package:genetic_algorithm/src/operator/crossover/crossover.dart';
import 'package:genetic_algorithm/src/operator/crossover/single_point_crossover.dart';

/// similer to [SinglePointCrossover] but is use to swap points.
/// and the genes before swap point 1 and after swap point 2 will be came
/// from parent 2 other genes will be came from parent 1.
class TowPointCrossover<T> extends Crossover<Iterable<T>> {
  TowPointCrossover({
    required super.probability,
    required super.selectionStrategy,
  });

  @override
  Iterable<T> crossover(Iterable<T> parent1, Iterable<T> parent2, Random rnd) {
    final offspring = <T>[];

    int swapPoint1 = rnd.nextInt(parent1.length);
    int swapPoint2 = swapPoint1 + rnd.nextInt(parent1.length - swapPoint1);

    for (int i = 0; i < parent1.length; i++) {
      if (i >= swapPoint1 && i < swapPoint2) {
        offspring.add(parent2.elementAt(i));
      } else {
        offspring.add(parent1.elementAt(i));
      }
    }

    return offspring;
  }
}
