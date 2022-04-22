class Option<T> {
  final List<T> _val;

  Option(T v) : _val = [v];

  Option.empty() : _val = [];

  Option<B> map<B>(B Function(T) f) {
    return isEmpty() ? Option.empty() : Option(f(get()));
  }

  Option<B> flatMap<B>(Option<B> Function(T) f) {
    return map(f).get();
  }

  bool isEmpty() {
    return _val.isEmpty;
  }

  Iterable<T> toIterable() {
    return _val;
  }

  T get() {
    return _val[0];
  }
}

Option<T> tryGet<T>(T Function() f) {
  try {
    return Option(f());
  } catch (e) {
    return Option.empty();
  }
}
