import 'dart:math';

import 'package:genetic_algorithm/src/core/chromosome.dart';
import 'package:genetic_algorithm/src/core/population.dart';
import 'package:genetic_algorithm/src/operator/genetic_operator.dart';

export './string_mutation.dart';
export './swap_mutation.dart';
export './uniform_mutation.dart';

/// The [Mutation] operator is an operator that alter the chromosome data
/// based on [probability].
abstract class Mutation<T> implements GeneticOperator<T> {
  final double probability;

  Mutation({
    required this.probability,
  });

  @override
  Population<T> apply(Population<T> population, Random rnd) {
    final chromosomes = <Chromosome<T>>[];

    for (int i = 0; i < population.length; i++) {
      final chromosome = population.elementAt(i);

      final offspring = mute(chromosome.data, rnd);
      chromosomes.add(Chromosome.data(offspring));
    }
    return Population(chromosomes);
  }

  /// define a way that the chromosome data (genes) will be altered.
  T mute(T chromosome, Random rnd);
}
