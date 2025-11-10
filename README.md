# Nexus Dashboard

> A modular mobile dashboard application demonstrating dynamic widget loading, shared state management, and offline-first architecture.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Framework & Libraries](#framework--libraries)
- [State Management](#state-management)
- [Offline Handling](#offline-handling)
- [CI/CD Strategy](#cicd-strategy)
- [Getting Started](#getting-started)
- [Adding New Widgets](#adding-new-widgets)
- [Project Structure](#project-structure)

---

## 🎯 Overview

Nexus Dashboard is a production-ready modular mobile application built with Flutter that showcases enterprise-level architecture patterns. The application serves as a personal systems dashboard where independent widgets (Notes, AI Chat, Analytics) can be dynamically loaded, managed, and updated without affecting the core application shell.

### Key Highlights

- **Dynamic Module Loading**: Widgets register themselves and load at runtime
- **Offline-First Architecture**: Full functionality without network connectivity
- **Clean Architecture**: Clear separation of concerns across layers
- **State Management**: BLoC pattern for predictable state handling
- **Synchronization**: Smart queue-based sync with conflict resolution
- **Error Resilience**: Module isolation prevents cascading failures

---

## 🏗️ Architecture

### High-Level Architecture Overview

Nexus Dashboard follows **Clean Architecture** principles with a **Modular Monolith** approach, enabling independent feature development while maintaining a single deployable unit.

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Notes     │  │  AI Chat    │  │  Analytics  │         │
│  │   Module    │  │   Module    │  │   Module    │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│         │                │                 │                 │
│         └────────────────┴─────────────────┘                │
│                          │                                   │
│                   ┌──────▼──────┐                           │
│                   │  Dashboard  │                           │
│                   │    Shell    │                           │
│                   └──────┬──────┘                           │
├──────────────────────────┼──────────────────────────────────┤
│                   Domain Layer                               │
│         ┌────────────────┴────────────────┐                 │
│         │  Business Logic & Entities      │                 │
│         │  Repository Interfaces          │                 │
│         └────────────────┬────────────────┘                 │
├──────────────────────────┼──────────────────────────────────┤
│                      Data Layer                              │
│    ┌─────────────────────┼─────────────────────┐           │
│    │                     │                      │           │
│ ┌──▼────┐          ┌─────▼─────┐         ┌────▼─────┐     │
│ │ Local │          │   Sync    │         │  Remote  │     │
│ │Storage│          │  Manager  │         │   API    │     │
│ │(Hive) │          │           │         │(Future)  │     │
│ └───────┘          └───────────┘         └──────────┘     │
└─────────────────────────────────────────────────────────────┘
```

### Module Architecture

Each feature module is self-contained with its own:
- **Domain Layer**: Entities and repository interfaces
- **Data Layer**: Models and repository implementations
- **Presentation Layer**: BLoC, UI pages, and module registration

```
Module Structure (e.g., Notes)
├── domain/
│   ├── entities/          # Business objects
│   └── repositories/      # Abstract contracts
├── data/
│   ├── models/            # Data transfer objects
│   └── repositories/      # Concrete implementations
└── presentation/
    ├── bloc/              # State management
    ├── pages/             # UI screens
    └── [feature]_module.dart  # Module registration
```

### Data Flow Architecture

```
User Action → BLoC Event → Repository → Data Source
     ↑                                        ↓
     └──────── BLoC State ← Repository ←─────┘
```

---

## ✨ Features

### 1. Dynamic Widget Loading
- Widgets implement `IModule` interface
- Runtime discovery via `ModuleRegistry`
- Hot-swappable without app restart
- Independent versioning per module

### 2. Three Core Modules

#### 📝 Notes Module
- Create, read, and delete notes
- Offline-first with automatic sync
- Search and filter capabilities
- Timestamp tracking

#### 💬 AI Chat Module
- Mock conversational AI interface
- Message history persistence
- Real-time typing simulation
- Clear chat functionality

#### 📊 Analytics Module
- Dashboard statistics overview
- Weekly activity visualization
- Storage usage tracking
- Last sync information

### 3. Offline Capabilities
- Full CRUD operations without network
- Automatic background synchronization
- Queue-based sync with retry logic
- Conflict resolution strategies

### 4. Error Handling
- Module-level error boundaries
- Graceful degradation
- User-friendly error messages
- Retry mechanisms

---

## 🛠️ Framework & Libraries

### Framework Choice: Flutter

**Why Flutter?**
- **Cross-platform efficiency**: Single codebase for iOS and Android
- **Native performance**: Compiles to ARM machine code
- **Rich ecosystem**: Extensive plugin library
- **Hot reload**: Rapid development iteration
- **Material Design**: Beautiful, consistent UI out-of-the-box
- **Strong typing**: Dart's null safety prevents runtime errors

### Core Libraries

| Library | Version | Purpose | Reasoning |
|---------|---------|---------|-----------|
| `flutter_bloc` | ^8.1.3 | State management | Predictable, testable state with clear separation of concerns |
| `get_it` | ^7.6.4 | Dependency injection | Loose coupling and easy testing |
| `hive` | ^2.2.3 | Local database | Fast, lightweight NoSQL storage for offline data |
| `connectivity_plus` | ^5.0.1 | Network detection | Monitor connectivity for sync operations |
| `equatable` | ^2.0.5 | Value equality | Simplify state comparisons in BLoC |
| `uuid` | ^4.1.0 | Unique IDs | Generate collision-free identifiers |
| `intl` | ^0.18.1 | Internationalization | Date formatting and localization support |

### Architecture Libraries

```yaml
State Management: BLoC Pattern
├── flutter_bloc: State management framework
├── equatable: Value equality for states/events
└── Provider: (via BLoC) Widget tree injection

Dependency Injection: Service Locator
└── get_it: Global service registry

Local Storage: Hive
├── hive: Core NoSQL database
└── hive_flutter: Flutter-specific initialization

Network: Connectivity Monitoring
└── connectivity_plus: Real-time network status
```

---

## 🔄 State Management

### Design Philosophy

Nexus Dashboard uses the **BLoC (Business Logic Component)** pattern for state management, providing:
- Clear separation between UI and business logic
- Predictable state changes via events
- Easy testing with mockable dependencies
- Scalable architecture for complex apps

### BLoC Architecture

```
┌─────────────┐
│     UI      │ Dispatches events
│   (Widget)  │────────────────────┐
└─────────────┘                    │
       │                           ▼
       │                    ┌─────────────┐
       │ Rebuilds on        │    BLoC     │
       │ state changes      │  (Business  │
       │                    │    Logic)   │
       │                    └─────────────┘
       │                           │
       │                           │ Calls methods
       │                           ▼
       │                    ┌─────────────┐
       │                    │ Repository  │
       │                    │ (Data Layer)│
       │                    └─────────────┘
       │                           │
       │                           ▼
       │                    ┌─────────────┐
       └────────────────────│Data Sources │
                            │(Hive, API)  │
                            └─────────────┘
```

### State Management Layers

#### 1. Dashboard-Level State
```dart
DashboardBloc
├── Manages module navigation
├── Tracks active modules
└── Coordinates module lifecycle
```

#### 2. Feature-Level State
```dart
NotesBloc, ChatBloc, AnalyticsBloc
├── Independent state per feature
├── No cross-module dependencies
└── Isolated state updates
```

#### 3. Communication Between Modules

Modules communicate through:
- **Shared Repository Layer**: Common data access
- **Event Broadcasting**: Via BLoC streams
- **Dashboard Coordinator**: Orchestrates cross-module actions

```dart
// Example: Analytics reads from Notes/Chat repositories
class AnalyticsBloc {
  final NoteRepository _noteRepo;
  final ChatRepository _chatRepo;
  
  // Aggregates data from multiple sources
  Future<void> _calculateStats() async {
    final notes = await _noteRepo.getNotes();
    final messages = await _chatRepo.getMessages();
    // Process statistics...
  }
}
```

---

## 💾 Offline Handling

### Offline-First Strategy

Nexus Dashboard implements a comprehensive offline-first architecture ensuring full functionality without network connectivity.

### Architecture Components

#### 1. Local Storage (Hive)

**Why Hive?**
- Zero native dependencies
- Fast read/write operations
- Type-safe storage
- Minimal storage footprint
- Built-in encryption support

**Storage Structure:**
```
Hive Boxes
├── notes_box: All note documents
├── messages_box: Chat message history
├── analytics_box: Cached statistics
└── sync_queue_box: Pending sync operations
```

#### 2. Caching Strategy

**Cache-First Approach:**
```
Read Operation Flow:
1. Check local cache (Hive)
2. Return cached data if available
3. Fetch from remote if cache miss
4. Update cache with remote data
5. Return data to UI

Write Operation Flow:
1. Update local cache immediately (Optimistic Update)
2. Add to sync queue
3. Notify UI of local change
4. Sync to remote when online
5. Resolve conflicts if any
```

#### 3. Synchronization Logic

**Sync Manager Architecture:**

```dart
SyncManager Components:
├── Connectivity Monitor: Detects network state changes
├── Sync Queue: Stores pending operations
├── Retry Logic: Exponential backoff for failed syncs
└── Conflict Resolver: Last-write-wins strategy
```

**Sync Queue Structure:**
```json
{
  "type": "save_note",
  "data": { /* operation data */ },
  "timestamp": "2025-11-09T10:30:00Z",
  "retries": 0,
  "maxRetries": 3
}
```

**Synchronization Flow:**

```
[Offline] User creates note
    ↓
Save to local Hive storage
    ↓
Add to sync queue
    ↓
Show success to user (optimistic UI)
    ↓
[Network restored]
    ↓
Sync Manager detects connectivity
    ↓
Process sync queue (FIFO)
    ↓
For each queued item:
  ├─ Attempt sync to remote
  ├─ On success: Remove from queue
  └─ On failure: Increment retry count
      └─ If retries < max: Keep in queue
      └─ If retries ≥ max: Log error, remove
```

### Conflict Resolution

**Strategy: Last-Write-Wins (LWW)**

```dart
Conflict Detection:
1. Compare timestamps: local vs remote
2. If remote is newer:
   └─ Overwrite local with remote data
3. If local is newer:
   └─ Push local changes to remote
4. If timestamps equal:
   └─ Use remote as source of truth
```

### Data Consistency Guarantees

- **Eventual Consistency**: All nodes converge to same state
- **Local-First**: Users never blocked by network issues
- **Transparent Sync**: Background synchronization
- **User Control**: Manual sync trigger available

---

## 🚀 CI/CD Strategy

### Overview

Nexus Dashboard implements a comprehensive CI/CD pipeline using **GitHub Actions** for automated building, testing, and deployment to both iOS App Store and Google Play Store.

### Pipeline Architecture

```
Code Push → GitHub Actions Trigger
    ↓
┌───────────────────────┐
│   Build & Test Stage  │
│  - Lint code          │
│  - Run unit tests     │
│  - Run widget tests   │
│  - Generate coverage  │
└───────────────────────┘
    ↓
┌───────────────────────┐
│    Build Stage        │
│  - Build APK/AAB      │
│  - Build iOS IPA      │
│  - Sign artifacts     │
└───────────────────────┘
    ↓
┌───────────────────────┐
│   Deploy Stage        │
│  - Deploy to Firebase │
│    App Distribution   │
│  - Deploy to TestFlight│
│  - Deploy to Play Store│
└───────────────────────┘
    ↓
┌───────────────────────┐
│  Notification Stage   │
│  - Slack notification │
│  - Email reports      │
└───────────────────────┘
```

### CI/CD Workflow Stages

#### 1. Continuous Integration (CI)

**Triggers:**
- Push to `main` or `develop` branch
- Pull request creation
- Manual workflow dispatch

**Jobs:**
- Code linting with `flutter analyze`
- Unit tests with coverage >80%
- Widget tests for UI components
- Integration tests (optional)

#### 2. Continuous Deployment (CD)

**Deployment Environments:**

| Environment | Trigger | Target |
|-------------|---------|--------|
| Development | Push to `develop` | Firebase App Distribution |
| Staging | Tag with `v*-beta` | TestFlight + Internal Testing |
| Production | Tag with `v*` | App Store + Play Store |

### Release Management Strategy

#### Versioning Strategy

**Semantic Versioning: `MAJOR.MINOR.PATCH+BUILD`**

```
Example: 1.2.3+45
├── 1: Major version (breaking changes)
├── 2: Minor version (new features)
├── 3: Patch version (bug fixes)
└── 45: Build number (auto-incremented)
```

#### Release Process

```
1. Development
   ↓
   Feature branches → develop
   
2. Testing
   ↓
   develop → staging
   Beta testing via TestFlight/Internal Testing
   
3. Production Release
   ↓
   staging → main
   Tag release (e.g., v1.0.0)
   Auto-deploy to stores
   
4. Hotfix (if needed)
   ↓
   main → hotfix/[issue]
   Tag patch release (e.g., v1.0.1)
   Auto-deploy
```

#### Feature Rollout Strategy

**Phased Rollout:**
```
Stage 1: Internal Testing (1-2 days)
   └─ QA team + stakeholders

Stage 2: Beta Testing (3-5 days)
   └─ 10% of users via Firebase Remote Config

Stage 3: Gradual Rollout (7-14 days)
   └─ 25% → 50% → 100% via Play Store staged rollout

Stage 4: Full Release
   └─ 100% of users
```

**Feature Flags:**
```dart
// Enable/disable features remotely
RemoteConfig.getValue('enable_new_analytics_widget');
```

### Automated Testing Strategy

```
Test Pyramid:
├── Unit Tests (70%)
│   └─ Test business logic, repositories, BLoCs
├── Widget Tests (20%)
│   └─ Test UI components in isolation
└── Integration Tests (10%)
    └─ Test complete user flows
```

### Monitoring & Rollback

**Post-Deployment Monitoring:**
- Crash reporting via Firebase Crashlytics
- Performance monitoring
- User analytics
- Error rate tracking

**Rollback Strategy:**
```
If critical issue detected:
1. Pause rollout immediately
2. Roll back to previous version
3. Fix issue in hotfix branch
4. Deploy patch with expedited review
```

---

## 🚦 Getting Started

### Prerequisites

```bash
# Required
Flutter SDK: >=3.0.0
Dart SDK: >=3.0.0

# Recommended
Android Studio / VS Code
Xcode (for iOS development)
Git
```

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/nexus_dashboard.git
cd nexus_dashboard

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run

# Optional: Run tests
flutter test

# Optional: Check for issues
flutter doctor
```

### Platform-Specific Setup

#### Android
```bash
# No additional setup required
flutter run -d android
```

#### iOS (macOS only)
```bash
cd ios
pod install
cd ..
flutter run -d iphone
```

---

## ➕ Adding New Widgets

Follow these steps to add a new widget module to Nexus Dashboard:

### Step 1: Create Module Structure

```bash
lib/features/[your_widget]/
├── domain/
│   ├── entities/
│   │   └── [entity].dart
│   └── repositories/
│       └── [repository].dart
├── data/
│   ├── models/
│   │   └── [model].dart
│   └── repositories/
│       └── [repository]_impl.dart
└── presentation/
    ├── bloc/
    │   ├── [widget]_bloc.dart
    │   ├── [widget]_event.dart
    │   └── [widget]_state.dart
    ├── pages/
    │   └── [widget]_page.dart
    └── [widget]_module.dart
```

### Step 2: Implement IModule Interface

```dart
// lib/features/your_widget/presentation/your_widget_module.dart

import 'package:flutter/material.dart';
import '../../../core/interfaces/i_module.dart';

class YourWidgetModule implements IModule {
  @override
  String get id => 'your_widget';

  @override
  String get title => 'Your Widget';

  @override
  IconData get icon => Icons.your_icon;

  @override
  Color get color => const Color(0xFFYOURCOLOR);

  @override
  String getRoute() => '/your_widget';

  @override
  int get priority => 4; // Display order

  @override
  Widget getWidget() {
    return BlocProvider(
      create: (_) => getIt<YourWidgetBloc>()..add(LoadData()),
      child: const YourWidgetPage(),
    );
  }
}
```

### Step 3: Create Domain Layer

```dart
// lib/features/your_widget/domain/entities/your_entity.dart

import 'package:equatable/equatable.dart';

class YourEntity extends Equatable {
  final String id;
  final String name;
  // Add your fields

  const YourEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

// lib/features/your_widget/domain/repositories/your_repository.dart

import '../entities/your_entity.dart';

abstract class YourRepository {
  Future<List<YourEntity>> getItems();
  Future<void> saveItem(YourEntity item);
  Future<void> deleteItem(String id);
}
```

### Step 4: Implement Data Layer

```dart
// lib/features/your_widget/data/models/your_model.dart

import '../../domain/entities/your_entity.dart';

class YourModel extends YourEntity {
  const YourModel({
    required super.id,
    required super.name,
  });

  factory YourModel.fromJson(Map<String, dynamic> json) {
    return YourModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// lib/features/your_widget/data/repositories/your_repository_impl.dart

import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/sync_manager.dart';
import '../../domain/entities/your_entity.dart';
import '../../domain/repositories/your_repository.dart';
import '../models/your_model.dart';

class YourRepositoryImpl implements YourRepository {
  final LocalStorage _storage;
  final SyncManager _syncManager;

  YourRepositoryImpl(this._storage, this._syncManager);

  @override
  Future<List<YourEntity>> getItems() async {
    // Implement storage logic
  }

  @override
  Future<void> saveItem(YourEntity item) async {
    // Save to local storage
    // Queue for sync
    await _syncManager.queueAction('save_item', data);
  }

  @override
  Future<void> deleteItem(String id) async {
    // Implement deletion logic
  }
}
```

### Step 5: Create BLoC

```dart
// lib/features/your_widget/presentation/bloc/your_widget_event.dart

abstract class YourWidgetEvent extends Equatable {
  const YourWidgetEvent();
  @override
  List<Object?> get props => [];
}

class LoadData extends YourWidgetEvent {}

// lib/features/your_widget/presentation/bloc/your_widget_state.dart

abstract class YourWidgetState extends Equatable {
  const YourWidgetState();
  @override
  List<Object?> get props => [];
}

class YourWidgetInitial extends YourWidgetState {}

class YourWidgetLoaded extends YourWidgetState {
  final List<YourEntity> items;
  const YourWidgetLoaded(this.items);
  @override
  List<Object?> get props => [items];
}

// lib/features/your_widget/presentation/bloc/your_widget_bloc.dart

class YourWidgetBloc extends Bloc<YourWidgetEvent, YourWidgetState> {
  final YourRepository _repository;

  YourWidgetBloc(this._repository) : super(YourWidgetInitial()) {
    on<LoadData>(_onLoadData);
  }

  Future<void> _onLoadData(LoadData event, Emitter emit) async {
    try {
      final items = await _repository.getItems();
      emit(YourWidgetLoaded(items));
    } catch (e) {
      // Handle error
    }
  }
}
```

### Step 6: Build UI

```dart
// lib/features/your_widget/presentation/pages/your_widget_page.dart

class YourWidgetPage extends StatelessWidget {
  const YourWidgetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Widget')),
      body: BlocBuilder<YourWidgetBloc, YourWidgetState>(
        builder: (context, state) {
          if (state is YourWidgetLoaded) {
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.items[index].name),
                );
              },
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
```

### Step 7: Register Dependencies

```dart
// lib/core/di/injection.dart

Future<void> setupDependencies() async {
  // ... existing code ...
  
  // Add your repository
  getIt.registerLazySingleton<YourRepository>(
    () => YourRepositoryImpl(getIt(), getIt()),
  );

  // Add your BLoC
  getIt.registerFactory(() => YourWidgetBloc(getIt()));
}
```

### Step 8: Register Module

```dart
// lib/features/dashboard/data/module_registry.dart

void registerModules() {
  _modules.clear();
  _modules.addAll([
    NotesModule(),
    ChatModule(),
    AnalyticsModule(),
    YourWidgetModule(), // Add your module here
  ]);
  
  _modules.sort((a, b) => a.priority.compareTo(b.priority));
}
```

### Step 9: Test Your Widget

```bash
# Hot reload to see your new widget
# It should appear on the dashboard automatically!

flutter run
```

### That's it! Your new widget is now integrated. 🎉

---

## 📂 Project Structure

```
nexus_dashboard/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── core/
│   │   ├── di/
│   │   │   └── injection.dart             # Dependency injection setup
│   │   ├── interfaces/
│   │   │   └── i_module.dart              # Module interface
│   │   ├── storage/
│   │   │   ├── local_storage.dart         # Hive wrapper
│   │   │   └── sync_manager.dart          # Sync logic
│   │   ├── theme/
│   │   │   ├── app_theme.dart             # Theme configuration
│   │   │   └── app_typography.dart        # Typography styles
│   │   └── widgets/
│   │       └── error_boundary.dart        # Error handling
│   └── features/
│       ├── dashboard/
│       │   ├── data/
│       │   │   └── module_registry.dart   # Module registration
│       │   └── presentation/
│       │       ├── bloc/                  # Dashboard state
│       │       └── pages/                 # Dashboard UI
│       ├── notes/                         # Notes module
│       ├── chat/                          # Chat module
│       └── analytics/                     # Analytics module
├── test/                                  # Unit tests
├── integration_test/                      # Integration tests
├── android/                               # Android native code
├── ios/                                   # iOS native code
├── .github/
│   └── workflows/
│       └── ci_cd.yml                      # CI/CD pipeline
└── pubspec.yaml                           # Dependencies
```

---

## 📈 Performance Considerations

- **Lazy Loading**: Modules loaded on-demand
- **Const Constructors**: Minimize widget rebuilds
- **ListView.builder**: Efficient list rendering
- **Image Caching**: Reduced memory footprint
- **State Optimization**: Only rebuild affected widgets

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 👤 Author

**Victor Loveday**  
Senior Mobile Developer  
[GitHub](https://github.com/droidchief) • [LinkedIn](https://linkedin.com/in/victorloveday)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- BLoC library maintainers
- Open source community

---

**Built with ❤️ using Flutter**