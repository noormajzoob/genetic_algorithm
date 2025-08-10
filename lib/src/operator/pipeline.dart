import 'dart:math';

import 'package:genetic_algorithm/src/core/population.dart';
import 'package:genetic_algorithm/src/operator/genetic_operator.dart';

/// A holder class apply the list of operators in [pipeline] squencely
/// to produce new population.
class OperatorsPipeline<T> implements GeneticOperator<T> {
  final List<GeneticOperator<T>> pipeline;

  OperatorsPipeline({required this.pipeline});

  @override
  Population<T> apply(Population<T> population, Random rnd) {
    Population<T> result = population;

    for (var operator in pipeline) {
      result = operator.apply(result, rnd);
    }

    return result;
  }
}
