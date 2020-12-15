class ValueWrapper<T> {
  const ValueWrapper(this.value);

  final T value;
}

class ActiveFavoriteUpdateStreamWrapper extends ValueWrapper<Stream<void>> {
  ActiveFavoriteUpdateStreamWrapper(Stream<void> stream) : super(stream);
}

class ActiveFavoriteUpdateSinkWrapper extends ValueWrapper<Sink<void>> {
  ActiveFavoriteUpdateSinkWrapper(Sink<void> sink) : super(sink);
}
