import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const Failure._();

  const factory Failure.noInternet() = _NoInternet;
  const factory Failure.timeout() = _Timeout;
  const factory Failure.invalidResponse() = _InvalidResponse;
  const factory Failure.server([int? statusCode]) = _Server;
  const factory Failure.unknown([String? message]) = _Unknown;

  R when<R>({
    required R Function() noInternet,
    required R Function() timeout,
    required R Function() invalidResponse,
    required R Function(int? statusCode) server,
    required R Function(String? message) unknown,
  }) {
    return switch (this) {
      _NoInternet() => noInternet(),
      _Timeout() => timeout(),
      _InvalidResponse() => invalidResponse(),
      _Server(statusCode: final code) => server(code),
      _Unknown(message: final msg) => unknown(msg),
    };
  }
}
