import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'de': {
      'app_title': 'SimplyCounter',
      'new': 'Neu',
      'new_counter': 'Neuer Counter',
      'name': 'Name',
      'start_value': 'Startwert (optional)',
      'cancel': 'Abbrechen',
      'create': 'Erstellen',
      'no_counters': 'Noch keine Counter',
      'rename': 'Umbenennen',
      'adjust': 'Anpassen',
      'reset': 'Zurücksetzen',
      'delete': 'Löschen',
      'delete_confirm_title': 'Löschen?',
      'delete_confirm_body': 'Dies entfernt den Counter dauerhaft.',
      'save': 'Speichern',
      'apply': 'Anwenden',
      'adjust_hint': 'Zahl (negativ zum subtrahieren)',
      'about_github': 'github.com/YONN2222/SimplyCounter',
      'about_text': 'GitHub:',
      'could_not_open': 'Konnte Browser nicht öffnen',
      'close': 'Schließen',
    },
    'en': {
      'app_title': 'SimplyCounter',
      'new': 'New',
      'new_counter': 'New Counter',
      'name': 'Name',
      'start_value': 'Start value (optional)',
      'cancel': 'Cancel',
      'create': 'Create',
      'no_counters': 'No counters yet',
      'rename': 'Rename',
      'adjust': 'Adjust',
      'reset': 'Reset',
      'delete': 'Delete',
      'delete_confirm_title': 'Delete?',
      'delete_confirm_body': 'This will permanently remove the counter.',
      'save': 'Save',
      'apply': 'Apply',
      'adjust_hint': 'Number (negative to subtract)',
      'about_github': 'github.com/YONN2222/SimplyCounter',
      'about_text': 'GitHub:',
      'could_not_open': 'Could not open browser',
      'close': 'Close',
    },
  };

  String t(String key) {
    final lang = locale.languageCode;
    return _localizedValues[lang]?[key] ?? _localizedValues['en']![key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
