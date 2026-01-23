# Flutter Project Structure Guide

## Introduction

A well-organized folder structure is essential for scalable, maintainable, and collaborative Flutter app development. Flutter projects are designed to separate platform-specific code, core app logic, assets, and configuration files, making it easy for teams to work together and for projects to grow in complexity.

## Folder & File Overview

| Folder/File         | Purpose                                                                 |
|--------------------|-------------------------------------------------------------------------|
| lib/               | Main Dart code: screens, widgets, models, services, main.dart           |
| ┣ main.dart        | App entry point, root widget, app initialization                        |
| ┣ screens/         | Full-page UI screens (e.g., login, home, products)                      |
| ┣ widgets/         | Reusable UI components (buttons, cards, etc.)                           |
| ┣ services/        | Business logic, API calls, state management (e.g., auth, cart)          |
| ┗ models/          | Data models (e.g., Product, User, CartItem)                             |
| android/           | Android-specific config, build scripts, native code                     |
| ios/               | iOS-specific config, Xcode project files, Info.plist                    |
| assets/            | Images, fonts, static files (must be declared in pubspec.yaml)          |
| test/              | Unit, widget, and integration tests                                     |
| pubspec.yaml       | Project config: dependencies, assets, fonts, environment                |
| .gitignore         | Files/folders to ignore in version control                              |
| README.md          | Project documentation, setup, usage, and notes                          |
| build/             | Auto-generated build outputs (ignored by git)                           |
| .dart_tool/, .idea/| IDE and Dart tool configs (auto-generated)                              |

## Example Folder Hierarchy

```
my_flutter_app/
├── android/
├── assets/
├── ios/
├── lib/
│   ├── main.dart
│   ├── screens/
│   ├── widgets/
│   ├── services/
│   └── models/
├── test/
├── pubspec.yaml
├── .gitignore
├── README.md
└── build/
```

## Reflection

- **Why understand the structure?**
  - Knowing the role of each folder/file helps you quickly locate code, debug issues, and onboard new team members.
  - It prevents code duplication and encourages best practices for code organization.

- **How does it help teamwork?**
  - A clean, modular structure allows multiple developers to work on different features (screens, services, widgets) without conflicts.
  - It supports code reviews, testing, and scaling the app as requirements grow.

---

> A clear project structure is the foundation for building robust, scalable, and maintainable Flutter apps—especially in a team environment.
