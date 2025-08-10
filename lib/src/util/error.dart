class GeneticError implements Exception {
  final String message;

  GeneticError(this.message);

  @override
  String toString() => '${runtimeType.toString()}: $message';
}
