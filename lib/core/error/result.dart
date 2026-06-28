import 'failures.dart';

export 'failures.dart';

/// A lightweight discriminated union that represents either a successful
/// value [S] or a failure [F extends Failure].
///
/// Used as the return type for all use-case and repository methods, replacing
/// nullable returns (`T?`) with an explicit success/failure channel.
///
/// Usage:
/// ```dart
/// final result = await loginUseCase(params);
/// result.fold(
///   onFailure: (f) => showError(f.message),
///   onSuccess: (entity) => navigate(entity),
/// );
/// ```
sealed class Result<S, F extends Failure> {
  const Result();

  bool get isSuccess => this is Success<S, F>;
  bool get isFailure => this is ResultFailure<S, F>;

  S get value => (this as Success<S, F>).data;
  F get error => (this as ResultFailure<S, F>).failure;

  T fold<T>({
    required T Function(F failure) onFailure,
    required T Function(S success) onSuccess,
  }) {
    return switch (this) {
      Success<S, F>(:final data) => onSuccess(data),
      ResultFailure<S, F>(:final failure) => onFailure(failure),
    };
  }
}

/// The success variant of [Result].
final class Success<S, F extends Failure> extends Result<S, F> {
  const Success(this.data);
  final S data;
}

/// The failure variant of [Result].
final class ResultFailure<S, F extends Failure> extends Result<S, F> {
  const ResultFailure(this.failure);
  final F failure;
}
