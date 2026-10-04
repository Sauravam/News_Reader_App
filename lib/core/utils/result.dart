import '../error/failures.dart';

sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.err(Failure failure) = Err<T>;

  bool get isSuccess => this is Success<T>;
  bool get isErr => this is Err<T>;

  T? get dataOrNull => switch (this) {
        Success(data: final d) => d,
        Err() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Success() => null,
        Err(failure: final f) => f,
      };

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) err,
  }) {
    return switch (this) {
      Success(data: final d) => success(d),
      Err(failure: final f) => err(f),
    };
  }
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Err<T> extends Result<T> {
  final Failure failure;
  const Err(this.failure);
}
