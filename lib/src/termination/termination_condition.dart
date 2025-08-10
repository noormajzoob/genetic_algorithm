import 'package:genetic_algorithm/src/core/population_data.dart';

export './elapsed_time_termination.dart';
export './generation_count_termination.dart';
export './stagination_termination.dart';
export './target_value_termination.dart';
export './user_cancel_termination.dart';

/// [TerminationCondition] is condition that tell the evolution engine to
/// stop evolving when it is met base on the [data] of the current population.
abstract interface class TerminationCondition<T> {
  bool shouldTerminate(PopulationData<T> data);
}
