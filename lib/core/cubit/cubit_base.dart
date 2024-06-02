import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CubitBase<State> extends Cubit<State> {
  CubitBase(final State initialState) : super(initialState);

  final Set<CancelableOperation> _asyncOperations = {};
  final Set<StreamSubscription> _streamSubscriptions = {};

  Future<T> executeAsync<T>(final Future<T> asyncFunction) {
    final operation = CancelableOperation.fromFuture(asyncFunction);
    _asyncOperations.add(operation);
    return operation.value;
  }

  @override
  void emit(final State state) {
    if (isClosed) return;
    super.emit(state);
  }

  void executeStream(final StreamSubscription subscription) {
    _streamSubscriptions.add(subscription);
  }

  @mustCallSuper
  @override
  Future<void> close() async {
    final operationsToCancelFutures = _asyncOperations
        .where((final operation) => !operation.isCanceled)
        .map((final operation) => operation.cancel())
        .toList();
    await Future.wait(operationsToCancelFutures);
    final subscriptionsToCancelFutures =
        _streamSubscriptions.map((final subscription) => subscription.cancel()).toList();
    await Future.wait(subscriptionsToCancelFutures);
    return super.close();
  }
}
