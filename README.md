# genetic\_algorithm

An extensible, composable **Genetic Algorithm (GA) framework for Dart**. Build search/optimization solutions by plugging in your own population factory, fitness evaluator, selection strategy, crossover & mutation operators, and termination conditions.

---

## Features

* **Two engines**: `GenerationEvolutionEngine` and `PlusSelectionStrategyEngine`
* **Composable operators** via `OperatorsPipeline`
* **Pluggable selection**: `RouletteWheelSelection`, `TournamentSelection`, `RankSelection`
* **Crossover operators** for `Iterable<T>` and `String`
* **Mutation operators** for `Iterable<T>` and `String`
* **Clear abstractions** for factories, fitness, and termination

---

## Install

```bash
dart pub add genetic_algorithm
```

Import the barrel file:

```dart
import 'package:genetic_algorithm/genetic_algorithm.dart';
```

---

## Quick Start: Evolve "HELLO WORLD"

Evolves a string from a given alphabet until it matches the target.

```dart
import 'dart:async';
import 'package:genetic_algorithm/genetic_algorithm.dart';

class HelloFitness implements FitnessEvaluator<String> {
  final String target;
  HelloFitness(this.target);

  @override
  double evaluate(String gene) {
    int score = 0;
    for (var i = 0; i < target.length; i++) {
      if (gene[i] == target[i]) score++;
    }
    return score.toDouble();
  }
}

Future<void> main() async {
  const target = 'HELLO WORLD';
  const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ ';

  // 1) Build the operators pipeline (selection → crossover → mutation)
  final selection = RouletteWheelSelection<String>();
  final crossover = StringCrossover(
    probability: 0.9,
    selectionStrategy: selection,
  );
  final mutation = StringMutation(
    alphabet,
    probability: 0.2,
  );
  final pipeline = OperatorsPipeline<String>(pipeline: [crossover, mutation]);

  // 2) Create the engine (Generational evolution)
  final engine = GenerationEvolutionEngine<String>(
    populationFactory: StringFactory(alphabet, target.length),
    fitnessEvaluator: HelloFitness(target),
    evolutionScheme: pipeline,
  );

  // Optional: print progress each generation
  engine.addDefultObserver(showBestChromosomeGenes: true);

  // 3) Configure and run
  final settings = EngineSetting<String>(
    populationSize: 200,
    eliteCount: 2,
    terminations: <TerminationCondition<String>>[
      // Stop when fitness reaches all-correct characters
      TargetValueTermination<String>(target.length.toDouble()),
      // Safety stop (max generations)
      GenerationCountTermination<String>(2000),
    ],
  );

  final best = await engine.evolve(settings);
  print('Result: $best');
}
```

**What this shows**

* `StringFactory(alphabet, length)` generates random chromosomes.
* Fitness is the number of matching characters.
* Parent selection is handled inside `StringCrossover` using the provided `SelectionStrategy`.
* `OperatorsPipeline` composes multiple operators in sequence.
* `EngineSetting` controls population size, elitism, and termination.

---

## Plus-Selection Engine

Keeps the best individuals from **parents + offspring**.

```dart
final plusEngine = PlusSelectionStrategyEngine<String>(
  populationFactory: StringFactory(alphabet, target.length),
  fitnessEvaluator: HelloFitness(target),
  evolutionScheme: pipeline,
  offspringMultiplier: 2, // generates populationSize * 2 parents for breeding
);

final bestPlus = await plusEngine.evolve(settings);
```

---

## Core Abstractions

All are exported from `package:genetic_algorithm/genetic_algorithm.dart`.

* **PopulationFactory<T>** → `generateRandomChromosome(Random rnd)`
* **FitnessEvaluator<T>** → `double evaluate(T gene)`
* **SelectionStrategy<T>** → `Chromosome<T> select(Population<T>, Random)`
* **Crossover<T>** (operator) → `crossover(T parent1, T parent2, Random)`
* **Mutation<T>** (operator) → `mute(T chromosome, Random)`
* **OperatorsPipeline<T>** → apply a sequence of operators
* **TerminationCondition<T>** → `bool shouldTerminate(PopulationData<T>)`
* **EngineSetting<T>** → population size, elitism, seeds, and terminations
* **EvolutionEngine<T>** → `evolve(...)` or `evolvePopulation(...)`

---

## Built-in Components

### Selection

* `RouletteWheelSelection<T>`
* `TournamentSelection<T>(selectionSize: int, probability: double)`
* `RankSelection<T>(delegate: SelectionStrategy<T>)`

### Crossover

* `StringCrossover` (for `String` genes)
* `SinglePointCrossover<Iterable<T>>`
* `TowPointCrossover<Iterable<T>>`
* `UniformCrossover<Iterable<T>>`
* `OrderedCrossover<Iterable<T>>`

### Mutation

* `StringMutation` (alphabet-driven replacements)
* `SwapMutation<Iterable<T>>`
* `UniformMutation<Iterable<T>>` (needs a `PopulationFactory<Iterable<T>>`)

### Termination Conditions

* `TargetValueTermination<T>(double value)`
* `GenerationCountTermination<T>(int count)`
* `ElapsedTimeTermination<T>(Duration maxDuration)`
* `StaginationTermination<T>(int generationLimit)`
* `UserCancelTermination<T>()`

---

## Customize

Create your own strategies by implementing the small, focused interfaces.

**Custom fitness**

```dart
class MyFitness implements FitnessEvaluator<MyGene> {
  @override
  double evaluate(MyGene gene) => /* compute score */ 0.0;
}
```

**Custom population factory**

```dart
class MyFactory extends PopulationFactory<MyGene> {
  @override
  MyGene generateRandomChromosome(Random rnd) {
    // build a valid random gene
    return /* ... */ throw UnimplementedError();
  }
}
```

**Custom selection**

```dart
class MySelection<T> implements SelectionStrategy<T> {
  @override
  Chromosome<T> select(Population<T> population, Random rnd) {
    // pick a parent from the population
    return population.fittestChromosome;
  }
}
```

**Custom operators**

```dart
class MyMutation<T> extends Mutation<T> {
  MyMutation({required super.probability});
  @override
  T mute(T chromosome, Random rnd) => chromosome; // tweak genes
}

class MyCrossover<T> extends Crossover<T> {
  MyCrossover({required super.probability, required super.selectionStrategy});
  @override
  T crossover(T p1, T p2, Random rnd) => p1; // combine parents
}
```

---

## Tips

* Use a small `eliteCount` (e.g., 1–5% of population) to preserve top solutions.
* Tune `probability` on operators: high crossover (≈0.8–0.95) and moderate mutation (≈0.05–0.3) are good starting points.
* Combine multiple termination conditions for robustness.
