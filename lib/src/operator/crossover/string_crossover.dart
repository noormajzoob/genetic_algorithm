import 'dart:math';

import 'package:genetic_algorithm/src/operator/crossover/crossover.dart';

/// [StringCrossover] is an operator appied to parents with string genes.
///
/// the new chromosome will have the genes that cames randomlly from parents.
class StringCrossover extends Crossover<String> {
  StringCrossover(
      {required super.probability, required super.selectionStrategy});

  @override
  String crossover(String parent1, String parent2, Random rnd) {
    assert(parent1.length == parent2.length,
        'The tow parents must have same length.');

    final codes = [...parent1.codeUnits];

    for (int i = 0; i < codes.length; i++) {
      final randomIndex = rnd.nextInt(codes.length);

      codes[randomIndex] = parent2.codeUnitAt(randomIndex);
    }

    return String.fromCharCodes(codes);
  }
}
