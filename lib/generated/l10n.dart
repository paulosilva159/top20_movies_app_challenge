// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `{voteQuantity}: Votes`
  String detailsTileVotesQtt(Object voteQuantity) {
    return Intl.message(
      '$voteQuantity: Votes',
      name: 'detailsTileVotesQtt',
      desc: '',
      args: [voteQuantity],
    );
  }

  /// `{score}: Score`
  String detailsTileScore(Object score) {
    return Intl.message(
      '$score: Score',
      name: 'detailsTileScore',
      desc: '',
      args: [score],
    );
  }

  /// `Details`
  String get detailsScreenTopTitle {
    return Intl.message(
      'Details',
      name: 'detailsScreenTopTitle',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get tryAgainMessage {
    return Intl.message(
      'Try Again',
      name: 'tryAgainMessage',
      desc: '',
      args: [],
    );
  }

  /// `Verify your connection!`
  String get connectionErrorMessage {
    return Intl.message(
      'Verify your connection!',
      name: 'connectionErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Error!`
  String get genericErrorMessage {
    return Intl.message(
      'Error!',
      name: 'genericErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `List`
  String get bottomNavigationItemListTitle {
    return Intl.message(
      'List',
      name: 'bottomNavigationItemListTitle',
      desc: '',
      args: [],
    );
  }

  /// `Grid`
  String get bottomNavigationItemGridTitle {
    return Intl.message(
      'Grid',
      name: 'bottomNavigationItemGridTitle',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}