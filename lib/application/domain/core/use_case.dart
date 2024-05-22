import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:uniscan/core/error/base_exception.dart';

abstract class UseCase<Input, Output> {
  const UseCase();

  Either<BaseException, Output> call(final Input params);
}

abstract class UseCaseNoInput<Output> {
  const UseCaseNoInput();

  Either<BaseException, Output> call();
}

abstract class AsyncUseCase<Input, Output> {
  const AsyncUseCase();

  Future<Either<BaseException, Output>> call(final Input params);
}

abstract class AsyncUseCaseNoInput<Output> {
  const AsyncUseCaseNoInput();

  Future<Either<BaseException, Output>> call();
}

abstract class StreamUseCase<Input, Output> {
  const StreamUseCase();

  StreamSubscription<Output> listen(
    final Input params,
    final void Function(Output event)? onData, {
    final Function? onError,
    final void Function()? onDone,
    final bool? cancelOnError,
  });
}

abstract class StreamUseCaseNoParams<Output> {
  const StreamUseCaseNoParams();

  StreamSubscription<Output> listen(
    final void Function(Output event)? onData, {
    final Function? onError,
    final void Function()? onDone,
    final bool? cancelOnError,
  });
}
