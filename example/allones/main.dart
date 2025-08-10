// In this example we will generate list of integers that contains just one.
import 'dart:math';
import 'dart:typed_data';

import 'package:genetic_algorithm/src/core/fitness_evaluator.dart';
import 'package:genetic_algorithm/src/factory/population_factory.dart';
import 'package:genetic_algorithm/src/engine/evolution_engine.dart';
import 'package:genetic_algorithm/src/engine/plus_selection_strategy_engine.dart';
import 'package:genetic_algorithm/src/operator/crossover/unifor_crossover.dart';
import 'package:genetic_algorithm/src/operator/mutation/mutation.dart';
import 'package:genetic_algorithm/src/operator/pipeline.dart';
import 'package:genetic_algorithm/src/selection/tournament_selection.dart';
import 'package:genetic_algorithm/src/termination/target_value_termination.dart';

class AllOnesFactory extends PopulationFactory<Iterable<int>> {
  final int length;

  AllOnesFactory(this.length);

  @override
  Uint8List generateRandomChromosome(Random rnd) {
    final data = List.generate(length, (index) => rnd.nextInt(2));

    return Uint8List.fromList(data);
  }
}

class AllOnesMutation extends Mutation<Iterable<int>> {
  AllOnesMutation({required super.probability});

  @override
  Uint8List mute(Iterable<int> data, Random rnd) {
    final offspring = [...data];

    for (int i = 0; i < data.length; i++) {
      if (probability > rnd.nextDouble()) {
        int gene = 1;
        if (offspring[i] == 1) {
          gene = 0;
        }
        offspring[i] = gene;
      }
    }

    return Uint8List.fromList(offspring);
  }
}

class AllOnesFitnessEvaluator implements FitnessEvaluator<Iterable<int>> {
  @override
  double evaluate(Iterable<int> chromosome) {
    int correct = 0;
    for (final gene in chromosome) {
      if (gene == 1) {
        correct++;
      }
    }

    return correct / chromosome.length;
  }
}

void main() async {
  final pipeline = OperatorsPipeline<Iterable<int>>(
    pipeline: [
      UniformCrossover(
        probability: 0.95,
        selectionStrategy:
            TournamentSelection(selectionSize: 15, probability: 0.9),
      ),
      AllOnesMutation(probability: 0.001),
    ],
  );
  final engine = PlusSelectionStrategyEngine(
    offspringMultiplier: 15,
    evolutionScheme: pipeline,
    populationFactory: AllOnesFactory(1000),
    fitnessEvaluator: AllOnesFitnessEvaluator(),
  )..addDefultObserver();

  final result = await engine.evolve(
    EngineSetting(
      eliteCount: 0,
      populationSize: 5,
      terminations: [
        TargetValueTermination(1),
      ],
    ),
  );

  print('Result: $result');
}
