import 'dart:io';
import 'package:l10n_gen/l10n_gen.dart';

void main() async {
  print('🌍 Welcome to l10n_gen - Flutter Localization Generator\n');

  // Ask for language codes
  print(
      '📝 Enter language codes (comma-separated) or type "all" for all languages:');
  print('   Examples: en,es,fr  OR  all');
  print('   Available: en, es, fr, de, hi, zh-cn, ar, pt, ja, ru, it, ko, tr');
  stdout.write('➤ ');

  final localesInput = stdin.readLineSync();
  if (localesInput == null || localesInput.trim().isEmpty) {
    print('❌ Error: Language codes cannot be empty.');
    exit(1);
  }

  final locales = localesInput.trim().split(',').map((e) => e.trim()).toList();

  // Ask for file path
  print('\n📂 Enter the path to your Dart file containing strings:');
  print(
      '   Examples: lib/constants/app_strings.dart  OR  example/apptexts.dart');
  stdout.write('➤ ');

  final inputPath = stdin.readLineSync();
  if (inputPath == null || inputPath.trim().isEmpty) {
    print('❌ Error: File path cannot be empty.');
    exit(1);
  }

  print('\n${'=' * 60}');
  print('🚀 Starting localization generation...');
  print('${'=' * 60}\n');

  try {
    final generator = L10nGenerator(
      inputPath: inputPath.trim(),
      requestedLocales: locales,
    );

    await generator.run();

    print('\n${'=' * 60}');
    print('✅ Generation Complete!');
    print('${'=' * 60}');
    print('\n📦 Files Generated:');
    print('   • lib/l10n/app_*.arb files (${locales.length} languages)');
    print('   • lib/l10n/l10n_extension.dart (BuildContext helper)');
    print('   • l10n.yaml (Flutter l10n configuration)');
    print('\n🎯 Next Steps:');
    print('   1. Add flutter_localizations to your pubspec.yaml');
    print('   2. Set "generate: true" under flutter: in pubspec.yaml');
    print('   3. Run: flutter pub get');
    print('   4. Run: flutter gen-l10n');
    print('   5. Use in code: context.l10n.yourVariableName');
    print('\n💡 Tip: Import the extension file to use context.l10n');
    print('   import \'package:your_app/l10n/l10n_extension.dart\';\n');
  } catch (e) {
    print('\n❌ Error: ${e.toString()}');
    exit(1);
  }
}
