import 'package:easy_l10n_gen/easy_l10n_gen.dart';

/// Example usage for easy_l10n_gen
///
/// To try locally:
///   dart pub global activate --source path .
///   easy_l10n_gen
///
/// After publishing to pub.dev:
///   dart pub global activate easy_l10n_gen
///   easy_l10n_gen
///
/// ---------------------------------------------------------
/// CLI INTERACTION:
/// ---------------------------------------------------------
/// The CLI will prompt you for:
///   1. Language codes (e.g., "en, es, fr" or "all")
///   2. Path to your Dart file containing strings (e.g. "lib/constants.dart")
///
/// ---------------------------------------------------------

void main() async {
  /// This file intentionally left minimal; the CLI is usually invoked from the shell.

  /// However, you can also trigger the generator programmatically in a script:
  print('Initializing L10nGenerator...');

  /// ignore: unused_local_variable
  final generator = L10nGenerator(
    inputPath: 'lib/app_strings.dart',
    requestedLocales: ['en', 'es', 'de'],
  );

  /// await generator.run();

  print(
      'Generator ready. Run "easy_l10n_gen" in terminal to use interactively.');
}
