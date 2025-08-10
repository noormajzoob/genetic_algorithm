import 'dart:math';

import 'package:genetic_algorithm/src/core/population.dart';

/// A [GeneticOperator] is an operator applied to generation to produce a new generation.
abstract interface class GeneticOperator<T> {
  Population<T> apply(Population<T> population, Random rnd);
}
