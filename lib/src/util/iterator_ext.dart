extension IterOfIter<T> on Iterable<Iterable<T>> {
  Iterable<T> unzip() {
    final result = <T>[];

    forEach(result.addAll);

    return result;
  }
}

extension Iter<T> on Iterable<T> {
  Iterable<M> mapIndexed<M>(M Function(T e, int i) toElement) {
    int index = 0;

    return map((e) => toElement(e, index++));
  }
}
