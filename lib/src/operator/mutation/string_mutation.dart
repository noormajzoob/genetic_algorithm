import 'dart:math';

import 'package:genetic_algorithm/src/operator/mutation/mutation.dart';

/// A [StringMutation] is mutation operator applied to chromosomes with String gene.
///
/// The mutation done using random chars from [alphabet] string and insert
/// it to random index in chromosome gene (string).
class StringMutation extends Mutation<String> {
  final String alphabet;

  StringMutation(this.alphabet, {required super.probability});

  @override
  String mute(String chromosome, Random rnd) => mutateString(chromosome, rnd);

  String mutateString(String s, Random rnd) {
    final codes = [...s.codeUnits];

    for (int i = 0; i < codes.length; i++) {
      if (probability > rnd.nextDouble()) {
        final oldIndex = rnd.nextInt(codes.length);
        final newIndex = rnd.nextInt(alphabet.length);

        codes[oldIndex] = alphabet.codeUnitAt(newIndex);
      }
    }

    return String.fromCharCodes(codes);
  }
}
