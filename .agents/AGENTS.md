# Project Rules

- **Use Class-based Widgets**: Never use helper functions/methods that return widgets (e.g. `Widget _buildHeader()`). Always create a separate `StatelessWidget` or `StatefulWidget` class.
- **Separate Files for Widgets**: Place separate widget classes in their own files rather than declaring multiple large widgets in a single file.
- **Maximum 300 Lines per File**: No widget or UI file should exceed 300 lines of code. If a file exceeds this limit, break it down into smaller, decoupled widget files.
- **Feature-Based MVVM Architecture**: Organize feature folders into clear layers based on complexity:
  - `models/` - Plain data structures/DTOs.
  - `mappers/` - Data transformation helpers (e.g., entity to DTO).
  - `datasource/` - Raw network/database data fetching.
  - `repository/` - Business logic and database coordination.
  - `services/` - Framework wrappers and system services.
  - `viewmodels/` - State and event handlers for views.
  - `views/` - UI screens and widgets.
  *Note: Simple features (like Splash) may only require `views/` and `viewmodels/`.*
- **State Management & Code Generation**: Use **Riverpod 3** with code generation (`@riverpod`, `riverpod_generator`) for state management. Migrate away from Provider step-by-step.
- **Theme Extensions for Custom Styling**: Never use hardcoded/ad-hoc semantic colors directly inside UI widgets (e.g. `AppColors.splashGreenBg` or `AppColors.splashOrangeBg`). Always define custom design token sets inside a custom `ThemeExtension` class, and access them reactively in widgets using `Theme.of(context).extension<AppThemeExtension>()`.
- **Riverpod 3 Development Guidelines**:
  - **Dependency Injection**: Use Riverpod providers to create and inject all service, datasource, and repository classes, avoiding manual constructor passing or global singletons.
  - **State Management**: Manage all view states and events using Riverpod providers and Notifier classes, keeping Views lightweight and reactive.
  - **Lifecycle Management**: Use Riverpod's native mechanisms (like `.onDispose`, `ref.onDispose`, `keepAlive()`) to automatically initialize, retain, and dispose of resources/controllers/streams.
  - **Async State Handling**: Handle asynchronous data fetching using Riverpod's `AsyncValue` to natively represent loading, success, and error states in the UI.
  - **Provider-based Communication & Caching**: Connect providers using `ref.watch` for reactivity, leveraging Riverpod's automatic caching and provider-to-provider communication capabilities to optimize data sharing and queries.

