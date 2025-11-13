# Professional Flutter Todo App

A feature-rich, production-ready Todo application built with Flutter following Clean Architecture principles and best practices.

## Features

- **CRUD Operations**: Create, Read, Update, and Delete todos
- **Persistent Storage**: All todos are saved locally using Hive
- **Filtering**: View all todos, active todos, or completed todos
- **Rich UI**: Material 3 design with smooth animations
- **State Management**: BLoC pattern for predictable state management
- **Clean Architecture**: Separation of concerns with data, domain, and presentation layers
- **Dependency Injection**: Using get_it for loose coupling
- **Comprehensive Testing**: Unit tests and widget tests included

## Architecture

This project follows **Clean Architecture** with a feature-first approach:

```
lib/
├── core/                          # Shared utilities
│   ├── constants/                 # App-wide constants
│   ├── errors/                    # Error handling
│   ├── storage/                   # Storage abstraction
│   └── di/                        # Dependency injection setup
├── features/
│   └── todo/
│       ├── data/                  # Data layer
│       │   ├── datasources/       # Local storage implementation
│       │   ├── models/            # Data models (Hive)
│       │   └── repositories/      # Repository implementation
│       ├── domain/                # Business logic layer
│       │   ├── entities/          # Business models
│       │   ├── repositories/      # Repository interfaces
│       │   └── usecases/          # Business logic
│       └── presentation/          # UI layer
│           ├── bloc/              # State management
│           ├── pages/             # Screens
│           └── widgets/           # Reusable widgets
└── main.dart
```

## Tech Stack

- **Flutter SDK**: ^3.9.2
- **State Management**: flutter_bloc ^8.1.3
- **Local Storage**: hive ^2.2.3, hive_flutter ^1.1.0
- **Dependency Injection**: get_it ^7.6.4
- **Code Generation**: build_runner ^2.4.6, hive_generator ^2.0.1
- **Testing**: bloc_test ^9.1.5, mocktail ^1.0.1
- **Utilities**: equatable ^2.0.5, uuid ^4.2.1

## Getting Started

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart 3.0 or higher

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd todo-flutter
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate Hive type adapters:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

### Running Tests

Run all tests:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

### Troubleshooting

**Analyzer errors before code generation:**
If you see errors like "TodoModelAdapter isn't defined" or "todo_model.g.dart hasn't been generated", this is expected. Simply run the code generation command:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Watching for changes during development:**
To automatically regenerate code when you make changes:
```bash
flutter pub run build_runner watch
```

**Clean and rebuild:**
If you encounter issues with generated files:
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

## Project Structure Details

### Core Layer
- **Constants**: App-wide constants (storage keys, filter types)
- **Errors**: Custom failure classes for error handling
- **Storage**: Abstract storage service interface
- **DI**: Dependency injection container setup

### Domain Layer (Business Logic)
- **Entities**: Pure Dart classes representing business models
- **Repositories**: Abstract interfaces defining data operations
- **Use Cases**: Individual business logic operations (Single Responsibility Principle)

### Data Layer
- **Models**: Concrete implementations with JSON and Hive serialization
- **Data Sources**: Local storage implementation using Hive
- **Repositories**: Concrete repository implementations

### Presentation Layer
- **BLoC**: State management using BLoC pattern
  - `TodoBloc`: Manages todo CRUD operations
  - `FilterCubit`: Manages filter state (All/Active/Completed)
- **Pages**: Main screens
- **Widgets**: Reusable UI components

## Key Design Patterns

1. **Clean Architecture**: Separation of concerns across layers
2. **Repository Pattern**: Abstraction of data sources
3. **BLoC Pattern**: Predictable state management
4. **Dependency Injection**: Loose coupling and testability
5. **SOLID Principles**: Maintainable and scalable code

## Features in Detail

### Todo Management
- ✅ Add new todos with title and description
- ✅ Edit existing todos
- ✅ Mark todos as complete/incomplete
- ✅ Delete individual todos (swipe to delete)
- ✅ Clear all completed todos

### Filtering
- 📋 **All**: View all todos
- ⏳ **Active**: View only incomplete todos
- ✅ **Completed**: View only completed todos

### Data Persistence
- All todos are automatically saved to local storage using Hive
- Data persists across app restarts
- Fast and efficient local database

## Testing

The project includes comprehensive tests:

- **Unit Tests**:
  - BLoC tests using bloc_test
  - Repository tests

- **Widget Tests**:
  - TodoPage widget tests
  - Individual widget component tests

## Future Enhancements

Potential features for future releases:
- 📅 Due dates for todos
- 🏷️ Categories/tags
- 🔍 Search functionality
- 🎨 Custom themes
- 🔔 Notifications
- ☁️ Cloud sync
- 📊 Statistics and insights

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.

## Author

Created as a professional Flutter app template demonstrating best practices in:
- Clean Architecture
- BLoC state management
- Local data persistence
- Comprehensive testing
- Material 3 design

---

**Happy Coding! 🚀**
