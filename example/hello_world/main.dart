// In this example we will generate specific string from provided alphbets.
// The target string is "hello world" from "(a - z) + space" alphabets.
import 'package:genetic_algorithm/src/core/fitness_evaluator.dart';
import 'package:genetic_algorithm/src/engine/evolution_engine.dart';
import 'package:genetic_algorithm/src/engine/plus_selection_strategy_engine.dart';
import 'package:genetic_algorithm/src/factory/string_factory.dart';
import 'package:genetic_algorithm/src/operator/crossover/string_crossover.dart';
import 'package:genetic_algorithm/src/operator/mutation/string_mutation.dart';
import 'package:genetic_algorithm/src/operator/pipeline.dart';
import 'package:genetic_algorithm/src/selection/tournament_selection.dart';
import 'package:genetic_algorithm/src/termination/target_value_termination.dart';

class StringFitnessEvaluator implements FitnessEvaluator<String> {
  final String target;

  StringFitnessEvaluator(this.target);

  @override
  double evaluate(String chromosomeGenes) {
    int match = 0;

    for (int i = 0; i < target.length; i++) {
      if (target[i] == chromosomeGenes[i]) {
        match += 1;
      }
    }
    return match / chromosomeGenes.length;
  }
}

void main(List<String> args) async {
  final alphabet = 'abcdefghijklmnopqrstuvwxyz ';
  final target = 'hello world';

  final pipeline = OperatorsPipeline(pipeline: [
    StringCrossover(
      probability: 0.95,
      selectionStrategy:
          TournamentSelection(selectionSize: 15, probability: 0.9),
    ),
    StringMutation(
      alphabet,
      probability: 0.01,
    ),
  ]);

  final engine = PlusSelectionStrategyEngine(
    populationFactory: StringFactory(alphabet, target.length),
    fitnessEvaluator: StringFitnessEvaluator(target),
    evolutionScheme: pipeline,
  )..addDefultObserver(showBestChromosomeGenes: true);

  final result = await engine.evolve(
    EngineSetting(
      populationSize: 100,
      terminations: [
        TargetValueTermination(1),
      ],
    ),
  );

  print('Result: ${result}');
}
