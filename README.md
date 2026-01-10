# l10n_gen CLI

l10n_gen is a powerful CLI tool for Flutter developers that treats Dart files as the source of truth for localization. Define your strings as Dart variables, and let the CLI handle ARB generation, configuration, and even automatic translation.

## ✨ Features

- **Dart-as-Source**: No more manual JSON/ARB editing. Define strings in type-safe Dart classes.
- **🤖 Auto-Translation**: Instantly translates your strings into target languages using Google Translate.
- **🔄 Watch Mode**: Listens for changes in your Dart file and regenerates translations in real-time.
- **Zero Config**: Automatically creates `l10n.yaml` and sets up the project structure.
- **DX Extension**: Generates a BuildContext helper to use `context.l10n.variableName`.
- **Global Reach**: Support for the top 15 global languages with a single `-l all` flag.

## 📦 Installation

**Activate globally from your terminal:**

```bash
dart pub global activate --source path .
```

**Flutter Project Setup:** Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any

flutter:
  generate: true # Required for Flutter's internal l10n tool
```

## 🛠 Usage

### 1. Create your strings file

Define your strings as `static const String` or `static String` variables:

```dart
// lib/constants/app_strings.dart
class AppStrings {
  static const String welcome = "Welcome back to our shop";
  static const String loginAction = "Sign In";
  static const String errorGeneric = "Something went wrong, try again.";
}
```

### 2. Run the CLI

Run this command in your project root:

```bash
# Generate for specific languages with auto-translation
l10n_gen -i lib/constants/app_strings.dart -l es,fr,hi

# OR generate for the top 15 global languages instantly
l10n_gen -i lib/constants/app_strings.dart -l all
```

### 3. Enable Watch Mode (Optional)

Keep your translations synced automatically as you type:

```bash
l10n_gen -i lib/constants/app_strings.dart -l es,fr --watch
```

### 4. Use in Flutter UI

The CLI generates a helper in `lib/l10n/l10n_extension.dart`.

```dart
import 'package:your_project/l10n/l10n_extension.dart';

// Use it anywhere with BuildContext
Text(context.l10n.welcome)
```

## 🌍 Supported "All" Locales

The `--locales all` flag generates and translates for:

**en**, **es**, **fr**, **de**, **hi**, **zh**, **ar**, **pt**, **ja**, **ru**, **it**, **ko**, **tr**

## 📄 Troubleshooting

- **Rate Limiting**: Google Translate (free tier) may throttle requests if you translate hundreds of keys into many languages at once. If this happens, run the command for fewer languages at a time.

- **Variable Extraction**: Ensure your variables are inside a class and marked as `static`.

## 🤝 Contributing

1. Fork the Project.
2. Create your Feature Branch (`git checkout -b feature/NewFeature`).
3. Commit your Changes (`git commit -m 'Add some NewFeature'`).
4. Push to the Branch (`git push origin feature/NewFeature`).
5. Open a Pull Request.

## 📜 License

Distributed under the MIT License. See LICENSE for more information.
