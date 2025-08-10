import 'dart:math';

import 'package:genetic_algorithm/src/core/chromosome.dart';
import 'package:genetic_algorithm/src/core/population.dart';

export './delegate_selection.dart';
export './rank_selection.dart';
export './roulette_wheel_selection.dart';
export './tournament_selection.dart';

abstract interface class SelectionStrategy<T> {
  Chromosome<T> select(Population<T> chromosomes, Random rnd);
}
