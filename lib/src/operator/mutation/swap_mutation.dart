import 'dart:math';

import 'package:genetic_algorithm/src/operator/mutation/mutation.dart';

/// A [SwapMutation] is mutation operator applied to chromosomes of
/// [Iterable] genes.
///
/// The mutation is done be swap tow elements randomlly in chromosome.
class SwapMutation<T> extends Mutation<Iterable<T>> {
  SwapMutation({required super.probability});

  @override
  Iterable<T> mute(Iterable<T> chromosome, Random rnd) {
    final offspring = [...chromosome];

    for (int i = 0; i < offspring.length; i++) {
      if (probability > rnd.nextDouble()) {
        int randomPos = rnd.nextInt(offspring.length);
        final temp = offspring[randomPos];
        offspring[randomPos] = offspring[i];
        offspring[i] = temp;
      }
    }

    return offspring;
  }
}
