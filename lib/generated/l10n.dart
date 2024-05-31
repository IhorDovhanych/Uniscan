// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Log in with Google`
  String get log_in_with_google {
    return Intl.message(
      'Log in with Google',
      name: 'log_in_with_google',
      desc: 'Title for sign in with google button',
      args: [],
    );
  }

  /// `Log out`
  String get log_out {
    return Intl.message(
      'Log out',
      name: 'log_out',
      desc: 'Title for log out button',
      args: [],
    );
  }

  /// `Nearest QR Code`
  String get nearest_qr_code {
    return Intl.message(
      'Nearest QR Code',
      name: 'nearest_qr_code',
      desc: 'Message about nearest qr code',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: 'item title',
      args: [],
    );
  }

  /// `URL`
  String get url {
    return Intl.message(
      'URL',
      name: 'url',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: 'title for close button',
      args: [],
    );
  }

  /// `Add QR Code`
  String get add_qr_code {
    return Intl.message(
      'Add QR Code',
      name: 'add_qr_code',
      desc: 'title for dialog screen',
      args: [],
    );
  }

  /// `Edit QR Code`
  String get edit_qr_code {
    return Intl.message(
      'Edit QR Code',
      name: 'edit_qr_code',
      desc: 'title for dialog screen',
      args: [],
    );
  }

  /// `QR code name`
  String get qr_code_name {
    return Intl.message(
      'QR code name',
      name: 'qr_code_name',
      desc: 'placeholder text',
      args: [],
    );
  }

  /// `https://example.com`
  String get example_url {
    return Intl.message(
      'https://example.com',
      name: 'example_url',
      desc: 'placeholder for url',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: 'Button title',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: 'Button title',
      args: [],
    );
  }

  /// `Add and visit`
  String get add_and_visit {
    return Intl.message(
      'Add and visit',
      name: 'add_and_visit',
      desc: 'Button title',
      args: [],
    );
  }

  /// `No scanned QR codes yet`
  String get no_scanned_qr_codes_yet {
    return Intl.message(
      'No scanned QR codes yet',
      name: 'no_scanned_qr_codes_yet',
      desc: 'no qr codes message',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
