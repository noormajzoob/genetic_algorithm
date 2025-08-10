import 'package:genetic_algorithm/src/core/chromosome.dart';
import 'package:genetic_algorithm/src/util/error.dart';

/// A [Population] is represent the generation of chromosome in evalution proccess.
class Population<T> extends Iterable<Chromosome<T>> {
  late final List<Chromosome<T>> _chromosomes;
  double fitness = -1;

  Population(this._chromosomes);

  // calcuate the average fitness of population.
  void calcAveFitness() {
    double totalFitness = 0;

    for (var chromosome in this) {
      totalFitness += chromosome.fitness;
    }

    fitness = totalFitness / length;
  }

  // sort population chromosomes based on thier fitness
  void sort() => _chromosomes.sort();

  Chromosome<T> operator [](int index) => _chromosomes[index];
  void operator []=(int index, Chromosome<T> chromosome) =>
      _chromosomes[index] = chromosome;

  // get sub chromosomes in range form start (inclusive) to end (execlusive).
  List<Chromosome<T>> subChromosomes(int start, [int? end]) =>
      _chromosomes.sublist(start, end);

  // get population with chromosomes in range form start (inclusive) to end (execlusive).
  Population<T> subPopulation(int start, [int? end]) =>
      Population(subChromosomes(start, end));

  @override
  Iterator<Chromosome<T>> get iterator => _chromosomes.iterator;

  Chromosome<T> get fittestChromosome {
    if (isEmpty) {
      throw GeneticError(
          'Trying to get fittest chromosome in empty population');
    }

    return _chromosomes.first;
  }

  /// split the population int sub populations with [splitLength]
  List<Population<T>> split(int splitLength) {
    int count = _chromosomes.length ~/ splitLength;
    if (_chromosomes.length % splitLength != 0) {
      count++;
    }

    final result = <Population<T>>[];

    for (int i = 0; i < count; i++) {
      final start = i * splitLength;
      final end = start + splitLength >= _chromosomes.length
          ? null
          : start + splitLength;

      result.add(subPopulation(start, end));
    }

    return result;
  }

  /// add the list of chromosomes to the end of population.
  void append(Iterable<Chromosome<T>> chromosomes) =>
      _chromosomes.addAll(chromosomes);

  /// redues list [populations] into single population.
  static Population<T> merge<T>(List<dynamic> populations) {
    double fitness = 0;
    final chromosomes = <Chromosome<T>>[];

    for (final elem in populations) {
      if (elem is List<Chromosome<T>>) {
        chromosomes.addAll(elem);
      }
      if (elem is Population<T>) {
        chromosomes.addAll(elem._chromosomes);
        if (elem.fitness != -1) {
          fitness += elem.fitness;
        }
      }
    }

    fitness = fitness == 0 ? -1 : fitness;
    return Population(chromosomes)..fitness = fitness;
  }

  @override
  String toString() =>
      'EvaluatedPopulation(fitness: $fitness, chromosomes: ${_chromosomes.join(', ')})';
}
