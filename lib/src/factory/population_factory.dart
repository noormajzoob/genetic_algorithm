import 'dart:math';

import 'package:genetic_algorithm/src/core/chromosome.dart';
import 'package:genetic_algorithm/src/core/population.dart';

export './string_factory.dart';

/// A [PopulationFactory] is contract to detemine how to create initial population chromosomes.
/// by implementing the [generateRandomChromosome] method.
abstract class PopulationFactory<T> {
  Population<T> generateInitialPopulation(int size, List<T> seeds, Random rnd) {
    final chromosomes = <Chromosome<T>>[
      ...seeds.map(
        (e) => Chromosome.data(e),
      )
    ];

    for (int i = seeds.length; i < size; i++) {
      chromosomes.add(Chromosome.data(generateRandomChromosome(rnd)));
    }

    return Population(chromosomes);
  }

  T generateRandomChromosome(Random rnd);
}
