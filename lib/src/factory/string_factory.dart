import 'dart:math';

import 'package:genetic_algorithm/src/factory/population_factory.dart';

/// [StringFactory] is population factory used to create random "string" chromosome with length [strLength] from
/// givien [alphabet].
class StringFactory extends PopulationFactory<String> {
  final String alphabet;
  final int strLength;

  StringFactory(this.alphabet, this.strLength);

  @override
  String generateRandomChromosome(Random rnd) {
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < strLength; i++) {
      buffer.write(alphabet[rnd.nextInt(alphabet.length)]);
    }

    return buffer.toString();
  }
}
