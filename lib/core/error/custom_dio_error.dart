import 'dart:io';

import 'package:dio/dio.dart';
import 'package:uniscan/core/extensions/string_x.dart';

import 'base_exception.dart';
import 'error_codes.dart';

class CustomDioError extends DioError {
  CustomDioError(final DioError dioError, this.code, [this.neededMessage, this.apiErrorCode])
      : super(
          requestOptions: dioError.requestOptions,
          response: dioError.response,
          type: dioError.type,
          error: dioError.error,
        );

  factory CustomDioError.fromRequestOption(
    final RequestOptions requestOptions,
    final String responseMessage, {
    final String? apiErrorCode,
  }) =>
      CustomDioError(DioError(requestOptions: requestOptions), ecResponseMessage, responseMessage, apiErrorCode);

  factory CustomDioError.fromDioError(
    final DioError dioError,
    final String? errorMessage, [
    final String? apiErrorCode,
  ]) {
    switch (dioError.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        return CustomDioError(dioError, ecTimeout);
      case DioErrorType.response:
        return CustomDioError(dioError, ecErrorMessage, errorMessage ?? dioError.message, apiErrorCode);
      case DioErrorType.other:
        return dioError.error is SocketException ||
                (dioError.error is HttpException &&
                    dioError.message.containsWithLowerCase('connection closed before full header was received'))
            ? CustomDioError(dioError, ecConnection)
            : CustomDioError(dioError, ecOther);
      default:
        return CustomDioError(dioError, ecOther);
    }
  }

  final String code;
  final String? neededMessage;
  final String? apiErrorCode;

  BaseException toBaseException(final StackTrace stackTrace, final String message) {
    switch (code) {
      case ecConnection:
      case ecTimeout:
        return BaseException(error: this, stack: stackTrace, code: code, message: message);
      case ecResponseMessage:
      case ecErrorMessage:
        return BaseException(
            error: this, stack: stackTrace, code: apiErrorCode ?? code, message: neededMessage ?? message);
      case ecOther:
        return BaseException(error: this, stack: stackTrace, code: code, message: message);
      default:
        return BaseException(error: this, stack: stackTrace, code: code, message: message);
    }
  }

  @override
  String toString() =>
      'CustomDioError{code: $code, neededMessage: $neededMessage, apiErrorCode:$apiErrorCode}\n\n${super.toString()}';
}
