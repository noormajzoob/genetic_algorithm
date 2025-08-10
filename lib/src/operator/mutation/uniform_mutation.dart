import 'dart:math';

import 'package:genetic_algorithm/src/factory/population_factory.dart';
import 'package:genetic_algorithm/src/operator/mutation/mutation.dart';

/// A [UniformMutation] is mutation operator applied to chromosomes of
/// [Iterable] genes.
///
/// The mutation is done by generate random (but valid) chromosome using population factory,
/// then replace the the genes of chromosomes with the randomlly created chromosome's genes
/// based on [probability]
class UniformMutation<T> extends Mutation<Iterable<T>> {
  final PopulationFactory<Iterable<T>> populationFactory;

  UniformMutation({
    required super.probability,
    required this.populationFactory,
  });

  @override
  Iterable<T> mute(Iterable<T> chromosome, Random rnd) {
    final randomData = populationFactory.generateRandomChromosome(rnd);
    final offspring = [...chromosome];

    for (int i = 0; i < offspring.length; i++) {
      if (probability > rnd.nextDouble()) {
        offspring[i] = randomData.elementAt(i);
      }
    }

    return offspring;
  }
}
