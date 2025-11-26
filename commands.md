# 🛠️ Nook In - Build Scripts & Commands

## 📦 Initial Setup Commands

### 1. Create Flutter Project
```bash
flutter create nook_in
cd nook_in
```

### 2. Replace pubspec.yaml
Replace the generated `pubspec.yaml` with the one provided

### 3. Get Dependencies
```bash
flutter pub get
```

### 4. Create Folder Structure
```bash
# Core
mkdir -p lib/core/di
mkdir -p lib/core/routing
mkdir -p lib/core/theme
mkdir -p lib/core/utils

# Features
mkdir -p lib/features/home/presentation/pages
mkdir -p lib/features/home/presentation/widgets
mkdir -p lib/features/home/data

mkdir -p lib/features/player/domain/models
mkdir -p lib/features/player/domain/repositories
mkdir -p lib/features/player/data/repositories
mkdir -p lib/features/player/presentation/bloc
mkdir -p lib/features/player/presentation/pages
mkdir -p lib/features/player/presentation/widgets

mkdir -p lib/features/shared/widgets

# Assets
mkdir -p assets/backgrounds
mkdir -p assets/sounds

# Gen (will be auto-created)
mkdir -p lib/gen
```

### 5. Create Files
Copy all the provided files to their respective locations:
- `lib/main.dart`
- `lib/app.dart`
- `lib/core/di/injection.dart`
- `lib/core/routing/app_router.dart`
- `lib/core/theme/app_theme.dart`
- `lib/core/theme/app_colors.dart`
- `lib/core/utils/constants.dart`
- `lib/core/utils/extensions.dart`
- `analysis_options.yaml` (in root)

---

## 🏗️ Build Commands

### Generate Code (Injectable + Freezed + Flutter Gen)
```bash
# One-time generation
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-rebuild on changes)
dart run build_runner watch --delete-conflicting-outputs

# Clean and rebuild
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Run App
```bash
# Development (with hot reload)
flutter run -d chrome

# Specific device
flutter run -d macos
flutter run -d windows
flutter run -d linux

# With specific web renderer
flutter run -d chrome --web-renderer html
flutter run -d chrome --web-renderer canvaskit
```

### Build for Production
```bash
# Web (optimized)
flutter build web --release --web-renderer canvaskit

# Web (smaller size, less features)
flutter build web --release --web-renderer html

# Android
flutter build apk --release
flutter build appbundle --release

# iOS (requires Mac)
flutter build ios --release

# Desktop
flutter build macos --release
flutter build windows --release
flutter build linux --release
```

---

## 🧪 Testing Commands

### Run Tests
```bash
# All tests
flutter test

# Specific test file
flutter test test/features/player/bloc/player_bloc_test.dart

# With coverage
flutter test --coverage

# View coverage (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Lint & Format
```bash
# Analyze code
flutter analyze

# Format code
dart format .

# Fix auto-fixable issues
dart fix --apply
```

---

## 📝 Makefile (Optional - Create at root)

```makefile
# Makefile for Nook In

.PHONY: help get build-runner run test clean deploy

help:
	@echo "Available commands:"
	@echo "  make get          - Get dependencies"
	@echo "  make build-runner - Generate code"
	@echo "  make run          - Run app on Chrome"
	@echo "  make test         - Run tests"
	@echo "  make clean        - Clean build files"
	@echo "  make deploy       - Build and deploy to Firebase"

get:
	flutter pub get

build-runner:
	dart run build_runner build --delete-conflicting-outputs

watch:
	dart run build_runner watch --delete-conflicting-outputs

run:
	flutter run -d chrome

test:
	flutter test

coverage:
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html

clean:
	flutter clean
	rm -rf lib/**/*.g.dart
	rm -rf lib/**/*.freezed.dart
	rm -rf lib/core/di/injection.config.dart
	rm -rf lib/gen/

deploy:
	flutter build web --release
	firebase deploy --only hosting

format:
	dart format .

analyze:
	flutter analyze

fix:
	dart fix --apply
```

---

## 🎯 Typical Workflow

### Starting Development
```bash
# Terminal 1: Watch mode for code generation
make watch

# Terminal 2: Run app
make run
```

### Before Commit
```bash
# Format code
make format

# Check lint
make analyze

# Run tests
make test
```

### Deploy to Firebase
```bash
# Build production web
flutter build web --release --web-renderer canvaskit

# Deploy (Phase 1: hosting only)
firebase deploy --only hosting
```

---

## 🔧 VS Code Tasks (Optional)

Create `.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Build Runner: Build",
      "type": "shell",
      "command": "dart run build_runner build --delete-conflicting-outputs",
      "problemMatcher": [],
      "group": {
        "kind": "build",
        "isDefault": true
      }
    },
    {
      "label": "Build Runner: Watch",
      "type": "shell",
      "command": "dart run build_runner watch --delete-conflicting-outputs",
      "isBackground": true,
      "problemMatcher": []
    },
    {
      "label": "Flutter: Run Web",
      "type": "shell",
      "command": "flutter run -d chrome",
      "problemMatcher": []
    },
    {
      "label": "Flutter: Test",
      "type": "shell",
      "command": "flutter test",
      "problemMatcher": []
    }
  ]
}
```

---

## 🚀 Quick Start Checklist

- [ ] Create project: `flutter create nook_in`
- [ ] Copy all provided files
- [ ] Run `flutter pub get`
- [ ] Run `dart run build_runner build --delete-conflicting-outputs`
- [ ] Run `flutter run -d chrome`
- [ ] See app running with placeholder pages ✅

**Next:** Move to STEP 2 (Domain Models) 🎯