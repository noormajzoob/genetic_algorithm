# Genetic Algorithm
It is fast, easy to use and extensable genetic algorithm implementaion for dart.

## Get started:
add the package to pubspec.yaml file.

```yaml
genetic_algorithm: ^1.0.0
```

## Evolution Engine
> Evolution is the proccess of produces new candidate solution (generation) from old generation.

There are tow type of engine implemented:

1. GenerationEvolutionEngine.
2. PlusSelectionStrategyEngine.

here is example of creating generation evoliton engine that evolve `List<int>` chromosomes.

```dart
final engine = GenerationEvolutionEngine<List<int>>(...);
```

to start evolution process call `evolve()` method of engine instance which accept `EngineSetting` and return the best soultion.

```dart
List<int> result = await engine.evolve(settings);
```

You can extends `EvolutionEngine` class to create your own behavior of evolution process.

## Population factory
> Its is factory used to create initial population and random chromosomes.


```dart
/// This factory is used to create bit (zero or one) chromosomes with specific [length].
class AllOnesFactory extends PopulationFactory<Iterable<int>> {
  final int length;

  AllOnesFactory(this.length);

  @override
  Uint8List generateRandomChromosome(Random rnd) {
    final data = List.generate(length, (index) => rnd.nextInt(2));

    return Uint8List.fromList(data);
  }
}
```

## Fitness evalutor
> its the judje of candidate soultion.

```dart
// The problem is to generate soultion with only one.
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
```

## Genetic Operator
> it is operator that applied to population to generate new population.
there are tow type of operators.
1. Crossover.
2. Mutation.

The package contains many built-in operators like:

1. SinglePointCrossover.
2. TowPointCrossover.
3. UniformCrossover.
4. SwapMutation.
5. etc.

You can create your own operator by extends `Crossover` or `Mutation` class or directly implement `GeneticOperator` class.

## Termination conditions
> The engine will evalute the generations until one of termination conditions is met.

There are serveral terminations:
1. Target value termination.
2. Elapsed time termination.
3. Generation count termination.
4. User cancel termination.
5. Stagination termination.

## Engine Setting
> Its settings that control the evolution process.

```dart
final settings = EngineSettigs(
    // The the of chromosomes in the each generation.
    populationSize: 100,
    // The number of chromosomes that will be moved to next generation without alteration,
    eliteCount: 2,
    // The list of chromosomes that will be added to first generation.
    seeds: [],
    // The list of conditions used to terminate the evalution process.
    terminations: [],
);
```

