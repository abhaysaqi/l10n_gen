# easy_l10n_gen CLI

easy_l10n_gen is a powerful CLI tool for Flutter developers that treats Dart files as the source of truth for localization. Define your strings as Dart variables, and let the CLI handle ARB generation, configuration, and even automatic translation.

## ✨ Features

- **Dart-as-Source**: No more manual JSON/ARB editing. Define strings in type-safe Dart classes.
- **🤖 Auto-Translation**: Instantly translates your strings into target languages using Google Translate.
- **Zero Config**: Automatically creates `l10n.yaml` and sets up the project structure.
- **DX Extension**: Generates a BuildContext helper to use `context.l10n.variableName`.
- **Global Reach**: Support for 136 global languages with a single `-l all` flag.

## 📦 Installation

**Activate globally from your terminal:**

**Option 1: Install from pub.dev**
```bash
dart pub global activate easy_l10n_gen
```

**Option 2: Activate locally from source**
```bash
dart pub global activate --source path .
```

**Flutter Project Setup:** Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any

flutter:f
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

Run the tool in your terminal:

```bash
easy_l10n_gen
```

The CLI is interactive and will guide you through the process:

```text
🌍 Welcome to easy_l10n_gen - Flutter Localization Generator

📝 Enter language codes (comma-separated) or type "all" for all languages:
   Examples: en,es,fr  OR  all
   Available: en, es, fr, de, hi, zh-cn, ar, pt, ja, ru, it, ko, tr
➤ en,hi,pa

📂 Enter the path to your Dart file containing strings:
   Examples: lib/constants/app_strings.dart  OR  example/apptexts.dart
➤ lib/constants/app_strings.dart
```

### 3. Use in Flutter UI

The CLI generates a helper in `lib/l10n/l10n_extension.dart`.

```dart
import 'package:your_project/l10n/l10n_extension.dart';

// Use it anywhere with BuildContext
Text(context.l10n.welcome)
```

## 🌍 Supported "All" Locales

<!-- **en**, **es**, **fr**, **de**, **hi**, **zh-cn**, **ar**, **pt**, **ja**, **ru**, **it**, **ko**, **tr** -->
**af**, **sq**, **am**, **ar**, **hy**, **as**, **ay**, **az**, **bm**, **eu**, **be**, **bn**, **bho**, **bs**, **bg**, **ca**, **ceb**, **zh-cn**, **zh-tw**, **co**, **hr**, **cs**, **da**, **dv**, **doi**, **nl**, **en**, **eo**, **et**, **ee**, **fil**, **fi**, **fr**, **fy**, **gaa**, **gl**, **ka**, **de**, **el**, **gn**, **gu**, **ht**, **ha**, **haw**, **iw**, **he**, **hi**, **hmn**, **hu**, **is**, **ig**, **ilo**, **id**, **ga**, **it**, **ja**, **jv**, **kn**, **kk**, **km**, **rw**, **gom**, **ko**, **kri**, **ku**, **ckb**, **ky**, **lo**, **la**, **lv**, **ln**, **lt**, **lg**, **lb**, **mk**, **mai**, **mg**, **ms**, **ml**, **mt**, **mi**, **mr**, **mni-mtei**, **lus**, **mn**, **my**, **ne**, **no**, **ny**, **or**, **om**, **ps**, **fa**, **pl**, **pt**, **pa**, **qu**, **ro**, **ru**, **sm**, **sa**, **gd**, **nso**, **sr**, **st**, **sn**, **sd**, **si**, **sk**, **sl**, **so**, **es**, **su**, **sw**, **sv**, **tl**, **tg**, **ta**, **tt**, **te**, **th**, **ti**, **ts**, **tr**, **tk**, **ak**, **uk**, **ur**, **ug**, **uz**, **vi**, **cy**, **xh**, **yi**, **yo**, **zu**


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
