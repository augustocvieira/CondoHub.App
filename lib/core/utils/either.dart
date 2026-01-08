class Either<L, R> {
  final L? _left;
  final R? _right;

  Either.left(L value)
      : _left = value,
        _right = null;
  Either.right(R value)
      : _left = null,
        _right = value;

  bool get isLeft => _left != null;
  bool get isRight => _right != null;

  L get left => _left!;
  R get right => _right!;

  T fold<T>(T Function(L) leftFunc, T Function(R) rightFunc) {
    if (isLeft) return leftFunc(_left!);
    return rightFunc(_right!);
  }
}
