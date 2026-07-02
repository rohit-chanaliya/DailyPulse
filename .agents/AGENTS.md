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

