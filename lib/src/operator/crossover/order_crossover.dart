import 'dart:math';

import 'package:genetic_algorithm/src/operator/crossover/crossover.dart';

/// The [OrderedCrossover] is an operator that modify the positons of chromosomes
/// genes.
class OrderedCrossover<T> extends Crossover<Iterable<T>> {
  OrderedCrossover(
      {required super.probability, required super.selectionStrategy});

  @override
  Iterable<T> crossover(Iterable<T> parent1, Iterable<T> parent2, Random rnd) {
    final offspring = List<T?>.generate(parent1.length, (index) => null);
    final pos1 = rnd.nextInt(parent1.length);
    final pos2 = pos1 + rnd.nextInt(parent1.length - pos1);

    for (int i = pos1; i <= pos2; i++) {
      offspring[i] = parent1.elementAt(i);
    }

    for (int i = 0; i < parent2.length; i++) {
      int offspringIndex = i + pos2 + 1;
      if (offspringIndex >= parent2.length) {
        offspringIndex -= parent2.length;
      }

      if (offspringIndex == pos1) {
        break;
      }

      for (int j = 0; j < parent2.length; j++) {
        final parent2Gene = parent2.elementAt(j);
        if (!offspring.contains(parent2Gene)) {
          offspring[offspringIndex] = parent2Gene;
          break;
        }
      }
    }

    return offspring.map((e) => e!);
  }
}
