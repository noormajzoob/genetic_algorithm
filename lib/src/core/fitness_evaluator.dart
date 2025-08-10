import 'package:genetic_algorithm/src/core/population.dart';
import 'package:genetic_algorithm/src/util/isolate_worker.dart';

/// A [FitnessEvaluator] is contract to define how much chromosome's genes
/// is fit.
abstract interface class FitnessEvaluator<T> {
  double evaluate(T gene);
}

class FitnessEvalutorTask<T> extends IsolateTask<Population<T>, Population<T>> {
  final FitnessEvaluator<T> fitnessEvaluator;

  FitnessEvalutorTask(
    super.payload, {
    required this.fitnessEvaluator,
  });

  @override
  Future<Population<T>> task(Population<T> payload) async {
    for (final chromosome in payload) {
      final data = chromosome.data;
      final fitness = fitnessEvaluator.evaluate(data);
      chromosome.fitness = fitness;
    }

    return payload;
  }
}
