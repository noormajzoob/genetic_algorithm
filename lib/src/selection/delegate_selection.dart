import 'dart:math';

import 'package:genetic_algorithm/src/core/chromosome.dart';
import 'package:genetic_algorithm/src/core/population.dart';
import 'package:genetic_algorithm/src/selection/selection_strategy.dart';

abstract class DelegateSelection<T> implements SelectionStrategy<T> {
  final SelectionStrategy<T> delegate;

  DelegateSelection({
    required this.delegate,
  });

  @override
  Chromosome<T> select(Population<T> population, Random rnd) {
    final mappedPopulation = mapPopulation(population);

    return delegate.select(mappedPopulation, rnd);
  }

  Population<T> mapPopulation(Population<T> population);
}
