import 'dart:math';

import 'package:genetic_algorithm/src/core/population.dart';
import 'package:genetic_algorithm/src/core/fitness_evaluator.dart';
import 'package:genetic_algorithm/src/core/population_data.dart';
import 'package:genetic_algorithm/src/factory/population_factory.dart';
import 'package:genetic_algorithm/src/operator/genetic_operator.dart';
import 'package:genetic_algorithm/src/termination/termination_condition.dart';
import 'package:genetic_algorithm/src/operator/pipeline.dart';
import 'package:genetic_algorithm/src/util/error.dart';
import 'package:genetic_algorithm/src/util/isolate_worker.dart';

export './generation_evolution_engine.dart';
export './plus_selection_strategy_engine.dart';

/// An [EvolutionObserver] is a method that tarck the proccess of the
/// evolution by recive a [data] represent summery of current generation.
typedef EvolutionObserver<T> = void Function(PopulationData<T> data);

/// An [EvolutionEngine] is engine that evolve the population to produce
/// the candidate soulution.
abstract class EvolutionEngine<T> extends EvolutionObserverBase<T> {
  /// A factory use to create the initial population.
  final PopulationFactory<T> populationFactory;

  /// A helper user to judge the validity of the chromosome.
  final FitnessEvaluator<T> fitnessEvaluator;

  /// An operator applied to the population to produce new population.
  /// see [OperatorsPipeline].
  final GeneticOperator<T> evolutionScheme;

  /// Evaluate population in single thread.
  final bool singleThread;

  final Random rnd;

  EvolutionEngine({
    required this.populationFactory,
    required this.fitnessEvaluator,
    required this.evolutionScheme,
    this.singleThread = false,
    Random? rnd,
  }) : rnd = rnd ?? Random();

  /// Start evolution proccess based on a [settings] to generate
  /// the candidate soultion [T].
  Future<T> evolve(
    EngineSetting<T> settings,
  ) async =>
      (await evolvePopulation(settings)).fittestChromosome.data;

  /// Start evolution proccess based on a [settings] to generate
  /// the best generation of candidate soultion [EvaluatedPopulation<T>]..
  Future<Population<T>> evolvePopulation(EngineSetting<T> settings) async {
    if (settings.terminations.isEmpty) {
      throw GeneticError('Termination conditions list must not be empty');
    }

    // generate initial population.
    Population<T> population = populationFactory.generateInitialPopulation(
      settings.populationSize,
      settings.seeds,
      rnd,
    );

    // keep tarck of the start time of evolution proccess.
    final startMillis = DateTime.now().millisecondsSinceEpoch;
    // evaluted the initial population.
    var evaluatedPopulation = await evaluatePopulation(population);

    // keep track of the generation index.
    int generationIndex = 1;

    // The data of the current evalutated population.
    // the data contains the population, generation index
    // and the time consumed by the current generation.
    var data = PopulationData(
      population: evaluatedPopulation,
      currentGeneration: generationIndex,
      currentDuration: Duration(
        milliseconds: DateTime.now().millisecondsSinceEpoch - startMillis,
      ),
    );
    // notify the observers about data of the current generation.
    _notifyObservers(data);

    // while there is no termination condition is met.
    while (!_hasToTerminate(data, settings.terminations)) {
      // generation the new population using templete method "nextPopulation()"
      // engine class delegate the implementation of this method to its sub classes.
      population =
          await nextPopulation(evaluatedPopulation, settings.eliteCount, rnd);
      // evaluate the generated population.
      evaluatedPopulation = await evaluatePopulation(population);

      // The data of the current evalutated population.
      data = PopulationData(
        population: evaluatedPopulation,
        currentGeneration: ++generationIndex,
        currentDuration: Duration(
          milliseconds: DateTime.now().millisecondsSinceEpoch - startMillis,
        ),
      );
      _notifyObservers(data);
    }

    return evaluatedPopulation;
  }

  /// Generate new population based on previous [population].
  /// The [eliteCount] is the count of chromosomes that moved to next
  /// population witout affect.
  Future<Population<T>> nextPopulation(
      Population<T> population, int eliteCount, Random rnd);

  /// helper method to check if there at least one of condition in
  /// [terminationConditions] list are met base on the [data] of current
  /// population.
  bool _hasToTerminate(PopulationData<T> data,
      List<TerminationCondition<T>> terminationConditions) {
    final results = terminationConditions.map((e) => e.shouldTerminate(data));

    return results.any((e) => e == true);
  }

  /// Get fitness value of each chromosome in [population]
  /// and return the evaluted population.
  Future<Population<T>> evaluatePopulation(Population<T> population) async {
    /// determine the number of pools needed to evaluate the population chromosomes.
    /// the maximum pools count is 5 if [singleThread] is set to false.
    int tasksCount = singleThread
        ? 1
        : population.length < 5
            ? population.length
            : 5;

    /// the size of chromosomes list for each task.
    final payloadSize = population.length ~/ tasksCount;

    if (population.length % tasksCount != 0) {
      tasksCount += 1;
    }

    /// the evalutor tasks
    final tasks = population
        .split(payloadSize)
        .map((e) => FitnessEvalutorTask(e, fitnessEvaluator: fitnessEvaluator))
        .toList();

    final pool =
        IsolateWorkerPool<Population<T>, Population<T>>(count: tasksCount);
    await pool.init();

    final result = await pool.sendMany(tasks);
    pool.destroy();

    return Population.merge(result)
      ..sort()
      ..calcAveFitness();
  }

  void addDefultObserver({bool showBestChromosomeGenes = false}) =>
      addObserver(_defaultObserver(showBestChromosomeGenes));
}

/// The [EngineSetting] is the setting of the evolution engine.
class EngineSetting<T> {
  // The size of chromosomes in each generation.
  final int populationSize;
  // The size of chromosomes that will be moved to the next generation
  // unaltered.
  final int eliteCount;
  // The chromosomes data that will be added to the first generation.
  final List<T> seeds;
  // List of conditions that used to stop evoluation process when
  // one of them is met.
  final List<TerminationCondition<T>> terminations;

  EngineSetting({
    required this.populationSize,
    this.eliteCount = 0,
    this.seeds = const [],
    required this.terminations,
  });
}

class EvolutionObserverBase<T> {
  final Set<EvolutionObserver<T>> _observers = {};

  void addObserver(EvolutionObserver<T> observer) {
    _observers.add(observer);
  }

  void deleteObserver(EvolutionObserver<T> observer) {
    _observers.remove(observer);
  }

  void _notifyObservers(PopulationData<T> data) {
    for (var observer in _observers) {
      observer.call(data);
    }
  }

  EvolutionObserver _defaultObserver(bool showBestFitnessGenes) {
    return (data) {
      String output =
          'Gen: ${data.currentGeneration}, Take:${data.currentDuration}, Best chromosome fitness: ${data.fittestChromosomeFitness}';

      if (showBestFitnessGenes) {
        output += ', Best chromosome: ${data.fittestChromosome.data}';
      }

      print(output);
    };
  }
}
