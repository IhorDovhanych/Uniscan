import 'package:logger/logger.dart';

void printKeyValue(final String key, final dynamic value) =>
    Logger(printer: PrettyPrinter(methodCount: 0)).i('$key: $value');

void printMessage(final String message) => Logger(printer: PrettyPrinter(methodCount: 0)).i(message);

void printError(final String message, [final dynamic e, final StackTrace? st]) =>
    Logger(printer: PrettyPrinter(methodCount: 1)).e(message);
