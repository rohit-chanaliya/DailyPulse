import 'app_component.dart';

AppComponent? _appComponent;

/// Global application dependency container instance.
/// Lazily creates the graph if not explicitly initialized.
AppComponent get appComponent => _appComponent ??= AppComponent.create();

/// Initializes the compile-time dependency injection graph.
void initDependencies({AppComponent? component}) {
  _appComponent = component ?? AppComponent.create();
}
