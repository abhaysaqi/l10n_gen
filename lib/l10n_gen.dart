import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'dart:convert';

import 'package:translator/translator.dart';

class L10nGenerator {
  final String inputPath;
  final List<String> locales;
  final GoogleTranslator _translator = GoogleTranslator();

  static const List<String> allLocales = [
    'en',
    'es',
    'fr',
    'de',
    'hi',
    'zh',
    'ar',
    'pt',
    'ja',
    'ru',
    'it',
    'ko',
    'tr'
  ];

  L10nGenerator(
      {required this.inputPath, required List<String> requestedLocales})
      : locales =
            requestedLocales.contains('all') ? allLocales : requestedLocales;

Future<void> run() async {
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
      print('⚠️ No static strings found. Use: static const String key = "value";');
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
