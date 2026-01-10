// import 'package:args/args.dart';
// import 'package:l10n_gen/l10n_gen.dart';

// void main(List<String> arguments) async {
//   final parser = ArgParser()
//     ..addOption(
//       'input',
//       abbr: 'i',
//       help: 'Path to your Dart file containing strings',
//       mandatory: true,
//     )
//     ..addOption(
//       'locales',
//       abbr: 'l',
//       help: 'Comma-separated language codes (e.g., en,es,fr) or "all"',
//       defaultsTo: 'en', // Changed from defaultValue to defaultsTo
//     );

//   try {
//     final res = parser.parse(arguments);

//     final generator = L10nGenerator(
//       inputPath: res['input'],
//       requestedLocales: (res['locales'] as String).split(','),
//     );

//     await generator.run();
//   } catch (e) {
//     print('❌ Error: ${e.toString()}');
//     print('\nUsage: l10n_gen -i <input_path> -l <locales>');
//     print(parser.usage);
//   }
// }

import 'dart:io';

import 'package:args/args.dart';
import 'package:l10n_gen/l10n_gen.dart';
import 'package:watcher/watcher.dart'; // Add this

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('input', abbr: 'i', mandatory: true)
    ..addOption('locales', abbr: 'l', defaultsTo: 'en')
    ..addFlag('watch',
        abbr: 'w', negatable: false, help: 'Watch for file changes');

  try {
    final res = parser.parse(arguments);
    final inputPath = res['input'] as String;
    final locales = (res['locales'] as String).split(',');
    final shouldWatch = res['watch'] as bool;

    final generator = L10nGenerator(
      inputPath: inputPath,
      requestedLocales: locales,
    );

    // Initial run
    await generator.run();

    if (shouldWatch) {
      print('👀 Watch mode enabled. Listening for changes in $inputPath...');

      final watcher = FileWatcher(inputPath);
      watcher.events.listen((event) async {
        if (event.type == ChangeType.MODIFY) {
          print('🔄 Change detected in ${event.path}. Regenerating...');
          await generator.run();
        }
      });

      // Keep the process alive
      await ProcessSignal.sigint.watch().first;
    }
  } catch (e) {
    print('❌ Error: $e');
  }
}
