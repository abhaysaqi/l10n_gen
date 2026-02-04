import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:translator/translator.dart';

class L10nGenerator {
  final String inputPath;
  final List<String> locales;
  final GoogleTranslator _translator = GoogleTranslator();

  static const List<String> allLocales = [
    // 'en',
    // 'es',
    // 'fr',
    // 'de',
    // 'hi',
    // 'zh-cn',
    // 'ar',
    // 'pt',
    // 'ja',
    // 'ru',
    // 'it',
    // 'ko',
    // 'tr'
    'af',
    'sq',
    'am',
    'ar',
    'hy',
    'as',
    'ay',
    'az',
    'bm',
    'eu',
    'be',
    'bn',
    'bho',
    'bs',
    'bg',
    'ca',
    'ceb',
    'zh-cn',
    'zh-tw',
    'co',
    'hr',
    'cs',
    'da',
    'dv',
    'doi',
    'nl',
    'en',
    'eo',
    'et',
    'ee',
    'fil',
    'fi',
    'fr',
    'fy',
    'gaa',
    'gl',
    'ka',
    'de',
    'el',
    'gn',
    'gu',
    'ht',
    'ha',
    'haw',
    'iw',
    'he',
    'hi',
    'hmn',
    'hu',
    'is',
    'ig',
    'ilo',
    'id',
    'ga',
    'it',
    'ja',
    'jv',
    'kn',
    'kk',
    'km',
    'rw',
    'gom',
    'ko',
    'kri',
    'ku',
    'ckb',
    'ky',
    'lo',
    'la',
    'lv',
    'ln',
    'lt',
    'lg',
    'lb',
    'mk',
    'mai',
    'mg',
    'ms',
    'ml',
    'mt',
    'mi',
    'mr',
    'mni-mtei',
    'lus',
    'mn',
    'my',
    'ne',
    'no',
    'ny',
    'or',
    'om',
    'ps',
    'fa',
    'pl',
    'pt',
    'pa',
    'qu',
    'ro',
    'ru',
    'sm',
    'sa',
    'gd',
    'nso',
    'sr',
    'st',
    'sn',
    'sd',
    'si',
    'sk',
    'sl',
    'so',
    'es',
    'su',
    'sw',
    'sv',
    'tl',
    'tg',
    'ta',
    'tt',
    'te',
    'th',
    'ti',
    'ts',
    'tr',
    'tk',
    'ak',
    'uk',
    'ur',
    'ug',
    'uz',
    'vi',
    'cy',
    'xh',
    'yi',
    'yo',
    'zu'
  ];

  L10nGenerator(
      {required this.inputPath, required List<String> requestedLocales})
      : locales =
            requestedLocales.contains('all') ? allLocales : requestedLocales;

  Future<void> run() async {
    final libDir = Directory('lib');
    if (!libDir.existsSync()) {
      print(
          '❌ Error: "lib" folder not found. Please run this from the root of a Flutter project.');
      return;
    }

    final file = File(inputPath);
    if (!file.existsSync()) {
      print('❌ Error: Input file not found: $inputPath');
      return;
    }

    final content = file.readAsStringSync();

    // Parse the string into an AST (Abstract Syntax Tree)
    final result = parseString(content: content);
    final Map<String, String> translations = {};

    for (var declaration in result.unit.declarations) {
      if (declaration is ClassDeclaration) {
        for (var member in declaration.members) {
          if (member is FieldDeclaration && member.isStatic) {
            for (var variable in member.fields.variables) {
              final name = variable.name.lexeme;
              final initializer = variable.initializer;
              if (initializer is StringLiteral) {
                translations[name] = initializer.stringValue ?? "";
              }
            }
          }
        }
      }
    }

    if (translations.isEmpty) {
      print(
          '⚠️ No static strings found. Use: static const String key = "value";');
      return;
    }

    print('⏳ Starting translation for ${locales.length} languages...');
    await _writeArbFiles(translations);
    _writeYaml();
    _writeExtension();

    print('\n🚀 Success! Files generated and translated.');
  }

  Future<void> _writeArbFiles(Map<String, String> sourceData) async {
    final dir = Directory('lib/l10n');
    if (!dir.existsSync()) dir.createSync(recursive: true);

    for (var locale in locales) {
      final file = File('lib/l10n/app_$locale.arb');
      Map<String, String> finalContent = {};

      if (locale == 'en') {
        finalContent = sourceData;
      } else {
        print('🌍 Translating to [$locale]...');
        for (var entry in sourceData.entries) {
          // Translate each value
          final translation =
              await _translator.translate(entry.value, from: 'en', to: locale);
          finalContent[entry.key] = translation.text;
        }
      }

      file.writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(finalContent));
    }
  }

  void _writeYaml() {
    File('l10n.yaml').writeAsStringSync('''arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
''');
  }

  void _writeExtension() {
    File('lib/l10n/l10n_extension.dart').writeAsStringSync('''
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
''');
  }
}
