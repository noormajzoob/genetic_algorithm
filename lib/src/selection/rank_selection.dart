import 'package:genetic_algorithm/src/core/chromosome.dart';
import 'package:genetic_algorithm/src/core/population.dart';
import 'package:genetic_algorithm/src/selection/delegate_selection.dart';
import 'package:genetic_algorithm/src/util/iterator_ext.dart';

class RankSelection<T> extends DelegateSelection<T> {
  RankSelection({
    required super.delegate,
  });

  double _mapToRank(int rank, int populationSize) =>
      (populationSize - rank).toDouble();

  @override
  Population<T> mapPopulation(Population<T> population) {
    final chromosomes = population.mapIndexed((e, i) {
      final chromosome = Chromosome.data(e.data);
      chromosome.fitness = _mapToRank(i, population.length);

      return chromosome;
    }).toList();

    return Population(chromosomes);
  }
}
